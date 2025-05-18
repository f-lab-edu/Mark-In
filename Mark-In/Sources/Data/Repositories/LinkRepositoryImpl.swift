//
//  LinkRepositoryImpl.swift
//  Mark-In
//
//  Created by 이정동 on 4/21/25.
//

import Foundation

import FirebaseFirestore
import FirebaseStorage

import LinkMetadataKitInterface

struct LinkRepositoryImpl: LinkRepository {
  
  typealias VoidCheckedContinuation = CheckedContinuation<Void, any Error>
  
  private let db = Firestore.firestore()
  private let storage = Storage.storage().reference()
  
  private let linkMetadataProvider: any LinkMetadataProvider
  
  init(linkMetadataProvider: any LinkMetadataProvider) {
    self.linkMetadataProvider = linkMetadataProvider
  }
  
  func create(userID: String, link: WriteLink) async throws -> Link {
    /// 1. Link 문서 참조 생성
    let path = FirebaseEndpoint.FirestoreDB.links(userID: userID).path
    let linkDocRef = db.collection(path).document()
        
    /// 2. URL의 메타데이터 가져오기
    let metadata = try await linkMetadataProvider.fetchMetadata(urlString: link.url).get()
    
    /// 3. 썸네일, 파비콘 이미지 업로드
    let imageUrls = try await uploadImageData(
      userID: userID,
      fileID: linkDocRef.documentID,
      metadata: metadata
    )
    
    /// 4. Firestore에 저장할 DTO 객체 생성
    let linkDTO = LinkDTO(
      id: linkDocRef.documentID,
      url: link.url,
      title: link.title ?? metadata.title,
      thumbnailUrl: imageUrls.thumbnail,
      faviconUrl: imageUrls.favicon,
      isPinned: false,
      createdBy: .now,
      lastAccessedAt: nil,
      folderID: link.folderID
    )
    
    /// 5. Firestore에 추가
    try await withCheckedThrowingContinuation { (continuation: VoidCheckedContinuation) in
      do {
        try linkDocRef.setData(from: linkDTO) { error in
          if let error { continuation.resume(throwing: error) }
          else { continuation.resume(returning: ()) }
        }
      } catch {
        continuation.resume(throwing: error)
      }
    }
    
    /// 6. 저장된 DTO 객체를 Entity로 변환 후 리턴
    return linkDTO.toEntity()
  }
  
  func fetchAll(userID: String) async throws -> [Link] {
    /// 1. Links 컬렉션 참조 생성
    let path = FirebaseEndpoint.FirestoreDB.links(userID: userID).path
    let linkColRef = db.collection(path)
    
    /// 2. 컬렉션의 모든 문서 가져오기
    let snapshot = try await linkColRef.getDocuments()
    
    /// 3. 문서를 DTO로 변환 후 다시 Entity로 변환
    return snapshot.documents.compactMap {
      try? $0.data(as: LinkDTO.self).toEntity()
    }
  }
  
  func update(userID: String, link: Link) async throws {
    /// 1. Link 문서 참조 생성
    let path = FirebaseEndpoint.FirestoreDB.link(userID: userID, linkID: link.id).path
    let linkDocRef = db.document(path)
    
    /// 2. Entity를 DTO로 변환
    let linkDTO = LinkDTO(
      id: link.id,
      url: link.url,
      title: link.title,
      thumbnailUrl: link.thumbnailUrl,
      faviconUrl: link.faviconUrl,
      isPinned: link.isPinned,
      createdBy: link.createdBy,
      lastAccessedAt: link.lastAccessedAt,
      folderID: link.folderID
    )
    
    /// 3. 업데이트
    try await withCheckedThrowingContinuation { (continuation: VoidCheckedContinuation) in
      do {
        try linkDocRef.setData(from: linkDTO) { error in
          if let error { continuation.resume(throwing: error) }
          else { continuation.resume(returning: ()) }
        }
      } catch {
        continuation.resume(throwing: error)
      }
    }
  }
  
  func delete(userID: String, link: Link) async throws {
    /// 1. Link 문서 참조 생성
    let path = FirebaseEndpoint.FirestoreDB.link(userID: userID, linkID: link.id).path
    let linkDocRef = db.document(path)
    
    /// 2. 이미지 데이터 삭제
    try await deleteImageData(userID: userID, fileID: linkDocRef.documentID)
    
    /// 3. Link 삭제
    try await linkDocRef.delete()
  }
}

private extension LinkRepositoryImpl {
  typealias ImageUrls = (thumbnail: String?, favicon: String?)
  
  func uploadImageData(
    userID: String,
    fileID: String,
    metadata: LinkMetadata
  ) async throws -> ImageUrls {
    
    /// 1. 썸네일, 파비콘 이미지 데이터를 저장할 storage 주소 생성
    let thumbnailPath = FirebaseEndpoint.Storage.thumbnail(userID: userID, thumbnailID: fileID).path
    let faviconPath = FirebaseEndpoint.Storage.favicon(userID: userID, faviconID: fileID).path
    
    let thumbnailRef = storage.child(thumbnailPath)
    let faviconRef = storage.child(faviconPath)
    
    /// 2. 이미지 데이터 업로드 후 참조 주소를 가져오는 과정을 비동기 병렬 처리
    let thumbnailTask: Task<String?, Error> = Task {
      guard let thumbnailData = metadata.thumbnail else { return nil }
      _ = try await thumbnailRef.putDataAsync(thumbnailData)
      let thumbnailUrl = try await thumbnailRef.downloadURL()
      return thumbnailUrl.absoluteString
    }
    
    let faviconTask: Task<String?, Error> = Task {
      guard let faviconData = metadata.favicon else { return nil }
      _ = try await faviconRef.putDataAsync(faviconData)
      let faviconUrl = try await faviconRef.downloadURL()
      return faviconUrl.absoluteString
    }
    
    /// 3. 썸네일, 파비콘 작업이 모두 완료된 후 리턴
    return try await (thumbnailTask.value, faviconTask.value)
  }
  
  func deleteImageData(userID: String, fileID: String) async throws {
    /// 1. 썸네일, 파비콘 이미지 참조 주소 생성
    let thumbnailPath = FirebaseEndpoint.Storage.thumbnail(userID: userID, thumbnailID: fileID).path
    let faviconPath = FirebaseEndpoint.Storage.favicon(userID: userID, faviconID: fileID).path
    
    let thumbnailRef = storage.child(thumbnailPath)
    let faviconRef = storage.child(faviconPath)
    
    /// 2. 이미지 데이터를 비동기 병렬 처리로 삭제
    try await withThrowingTaskGroup(of: Void.self) { group in
      group.addTask {
        try await thumbnailRef.delete()
      }
      
      group.addTask {
        try await faviconRef.delete()
      }
      
      /// 작업 취소에 대한 에러를 던질 수 있도록 하기 위함
      try await group.waitForAll()
    }
  }
}
