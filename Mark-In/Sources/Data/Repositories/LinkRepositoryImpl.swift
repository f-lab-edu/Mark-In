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
  
  typealias LinkFieldKey = FirestoreFieldKey.Link
  
  private let db = Firestore.firestore()
  private let storage = Storage.storage().reference()
  
  private let linkMetadataProvider: any LinkMetadataProvider
  
  init(linkMetadataProvider: any LinkMetadataProvider) {
    self.linkMetadataProvider = linkMetadataProvider
  }
  
  func create(userID: String, link: WriteLink) async throws -> WebLink {
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
    
    /// 4. 필드 값 설정
    let title = link.title ?? metadata.title
    let createdAt = Date()
    
    /// 5. Firestore에 추가
    try await linkDocRef.setData([
      LinkFieldKey.id: linkDocRef.documentID,
      LinkFieldKey.url: link.url,
      LinkFieldKey.title: title ?? NSNull(),
      LinkFieldKey.thumbnailUrl: imageUrls.thumbnail ?? NSNull(),
      LinkFieldKey.faviconUrl: imageUrls.favicon ?? NSNull(),
      LinkFieldKey.isPinned: false,
      LinkFieldKey.createdAt: createdAt,
      LinkFieldKey.lastAccessedAt: NSNull(),
      LinkFieldKey.folderID: link.folderID ?? NSNull()
    ])
    
    /// 6. 생성된 데이터 반환
    let linkEntity = WebLink(
      id: linkDocRef.documentID,
      url: link.url,
      title: title,
      thumbnailUrl: imageUrls.thumbnail,
      faviconUrl: imageUrls.favicon,
      isPinned: false,
      createdAt: createdAt,
      lastAccessedAt: nil,
      folderID: link.folderID
    )
    
    return linkEntity
  }
  
  func fetchAll(userID: String) async throws -> [WebLink] {
    /// 1. Links 컬렉션 참조 생성
    let path = FirebaseEndpoint.FirestoreDB.links(userID: userID).path
    let linkColRef = db.collection(path)
    
    /// 2. 컬렉션의 모든 문서 가져오기
    let snapshot = try await linkColRef.getDocuments()
    
    /// 3. 문서를 DTO로 변환 후 다시 Entity로 변환
    return snapshot.documents.compactMap {
      try? $0.data(as: WebLinkDTO.self).toEntity()
    }
  }
  
  
  func moveLinkInFolder(
    userID: String,
    target linkID: String,
    to folderID: String?
  ) async throws {
    /// 1. Link 문서 참조 생성
    let path = FirebaseEndpoint.FirestoreDB.link(userID: userID, linkID: linkID).path
    let linkDocRef = db.document(path)
    
    /// 2. 문서 업데이트
    try await linkDocRef.updateData([
      LinkFieldKey.folderID: folderID ?? NSNull()
    ])
  }
  
  func moveLinksInFolder(
    userID: String,
    fromFolderID: String?,
    toFolderID: String?
  ) async throws {
    /// 1. Link 컬렉션 참조 생성
    let path = FirebaseEndpoint.FirestoreDB.links(userID: userID).path
    let linkColRef = db.collection(path)
    
    /// 2. 조건에 해당하는 모든 문서 가져오기
    let querySnapshot = try await linkColRef
      .whereField(LinkFieldKey.folderID, isEqualTo: fromFolderID ?? NSNull())
      .getDocuments()
    
    /// 3. 병렬 작업으로 문서 업데이트
    try await withThrowingTaskGroup(of: Void.self) { group in
      querySnapshot.documents.forEach { document in
        group.addTask {
          try await document.reference.updateData([
            LinkFieldKey.folderID: toFolderID ?? NSNull()
          ])
        }
      }
      
      try await group.waitForAll()
    }
  }
  
  func delete(userID: String, linkID: String) async throws {
    /// 1. Link 문서 참조 생성
    let path = FirebaseEndpoint.FirestoreDB.link(userID: userID, linkID: linkID).path
    let linkDocRef = db.document(path)
    
    /// 2. 이미지 데이터 삭제
    try await deleteImageData(userID: userID, fileID: linkDocRef.documentID)
    
    /// 3. Link 삭제
    try await linkDocRef.delete()
  }
  
  func deleteAllInFolder(userID: String, folderID: String?) async throws {
    let path = FirebaseEndpoint.FirestoreDB.links(userID: userID).path
    let querySnapshot = try await db.collection(path)
      .whereField(LinkFieldKey.folderID, isEqualTo: folderID ?? NSNull())
      .getDocuments()
    
    /// 3. 병렬 작업으로 데이터 삭제
    try await withThrowingTaskGroup(of: Void.self) { group in
      /// 모둔 문서에 순차 접근
      querySnapshot.documents.forEach { document in
        /// Link 데이터 삭제
        group.addTask {
          try await document.reference.delete()
        }
        
        /// 이미지 데이터 삭제
        group.addTask {
          try await deleteImageData(userID: userID, fileID: document.documentID)
        }
      }
      
      try await group.waitForAll()
    }
  }
  
  func deleteAll(userID: String) async throws {
    /// 1. Links 컬렉션 참조 생성
    let path = FirebaseEndpoint.FirestoreDB.links(userID: userID).path
    let linkColRef = db.collection(path)
    
    /// 2. 컬렉션의 모든 문서 가져오기
    let snapshot = try await linkColRef.getDocuments()
    
    /// 3. 병렬 작업으로 데이터 삭제
    try await withThrowingTaskGroup(of: Void.self) { group in
      /// 모둔 문서에 순차 접근
      snapshot.documents.forEach { document in
        /// Link 데이터 삭제
        group.addTask {
          try await document.reference.delete()
        }
        
        /// 이미지 데이터 삭제
        group.addTask {
          try await deleteImageData(userID: userID, fileID: document.documentID)
        }
      }
      
      try await group.waitForAll()
    }
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
