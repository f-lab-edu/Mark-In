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
    
    /// 2. 필드 값 생성
    let createdAt = Date()
    
    /// 3. Firestore에 추가
    try await folderDocRef.setData([
      "id": folderDocRef.documentID,
      "name": folder.name,
      "createdAt": createdAt
    ])
    
    /// 4. 생성된 데이터 반환
    let folderEntity = Folder(
      id: folderDocRef.documentID,
      name: folder.name,
      createdAt: .now
    )
    
    return folderEntity
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
  
  func delete(userID: String, folderID: String) async throws {
    /// 1. Folder 문서 참조 생성
    let path = FirebaseEndpoint.FirestoreDB.folder(userID: userID, folderID: folderID).path
    let folderDocRef = db.document(path)
    
    /// 2. Folder 삭제
    try await folderDocRef.delete()
  }
  
  func deleteAll(userID: String) async throws {
    /// 1. Folders 컬렉션 참조 생성
    let path = FirebaseEndpoint.FirestoreDB.folders(userID: userID).path
    let folderColRef = db.collection(path)
    
    /// 2. 컬렉션의 모든 문서 가져오기
    let snapshot = try await folderColRef.getDocuments()
    
    /// 3. 모든 데이터 병렬 작업으로 삭제
    try await withThrowingTaskGroup(of: Void.self) { group in
      snapshot.documents.forEach { document in
        group.addTask {
          try await document.reference.delete()
        }
      }
      
      try await group.waitForAll()
    }
  }
}
