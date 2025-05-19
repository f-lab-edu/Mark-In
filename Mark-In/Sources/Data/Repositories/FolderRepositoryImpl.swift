//
//  FolderRepositoryImpl.swift
//  Mark-In
//
//  Created by 이정동 on 4/21/25.
//

import Foundation

import FirebaseFirestore

struct FolderRepositoryImpl: FolderRepository {
  
  typealias VoidCheckedContinuation = CheckedContinuation<Void, any Error>
  
  private let db = Firestore.firestore()
  
  func create(userID: String, folder: WriteFolder) async throws -> Folder {
    /// 1. Folder 문서 참조 생성
    let path = FirebaseEndpoint.FirestoreDB.folders(userID: userID).path
    let folderDocRef = db.collection(path).document()
    
    /// 2. Firestore에 저장할 DTO 객체 생성
    let folderDTO = FolderDTO(
      id: folderDocRef.documentID,
      name: folder.name,
      createdBy: .now
    )
    
    /// 3. Firestore에 추가
    try await withCheckedThrowingContinuation { (continuation: VoidCheckedContinuation) in
      do {
        try folderDocRef.setData(from: folderDTO) { error in
          if let error { continuation.resume(throwing: error) }
          else { continuation.resume(returning: ()) }
        }
      } catch {
        continuation.resume(throwing: error)
      }
    }
    
    /// 4. DocumentID가 업데이트 된 Folder Entity로 리턴
    return folderDTO.toEntity()
  }
  
  func fetchAll(userID: String) async throws -> [Folder] {
    /// 1. Folders 컬렉션 참조 생성
    let path = FirebaseEndpoint.FirestoreDB.folders(userID: userID).path
    let folderColRef = db.collection(path)
    
    /// 2. 컬렉션의 모든 문서 가져오기
    let snapshot = try await folderColRef.getDocuments()
    
    /// 3. 문서를 DTO로 변환 후 다시 Entity로 변환
    return snapshot.documents.compactMap {
      try? $0.data(as: FolderDTO.self).toEntity()
    }
  }
  
  func update(userID: String, folder: Folder) async throws {
    /// 1. Folder 문서 참조 생성
    guard let folderID = folder.id else { return }
    let path = FirebaseEndpoint.FirestoreDB.folder(userID: userID, folderID: folderID).path
    let folderDocRef = db.document(path)
    
    /// 2. Entity를 DTO로 변환
    let folderDTO = FolderDTO(
      id: folderDocRef.documentID,
      name: folder.name,
      createdBy: folder.createdBy
    )
    
    /// 3. 업데이트
    try await withCheckedThrowingContinuation { (continuation: VoidCheckedContinuation) in
      do {
        try folderDocRef.setData(from: folderDTO) { error in
          if let error { continuation.resume(throwing: error) }
          else { continuation.resume(returning: ()) }
        }
      } catch {
        continuation.resume(throwing: error)
      }
    }
  }
  
  func delete(userID: String, folder: Folder) async throws {
    /// 1. Folder 문서 참조 생성
    guard let folderID = folder.id else { return }
    let path = FirebaseEndpoint.FirestoreDB.folder(userID: userID, folderID: folderID).path
    let folderDocRef = db.document(path)
    
    /// 2. Folder 삭제
    try await folderDocRef.delete()
  }
}
