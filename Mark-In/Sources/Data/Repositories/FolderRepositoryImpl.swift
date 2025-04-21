//
//  FolderRepositoryImpl.swift
//  Mark-In
//
//  Created by 이정동 on 4/21/25.
//

import Foundation

import FirebaseFirestore

struct FolderRepositoryImpl: FolderRepository {
  
  private let db = Firestore.firestore()
  
  func createFolder(_ folder: Folder) throws -> Folder {
    /// 1. Folder 문서 참조 생성
    // TODO: 후에 testUser를 실제 로그인 된 유저로 변경 예정
    let folderDocRef = db.collection("users/testUser/folders").document()
    
    /// 2. Entity를 DTO로 변환 및 새로 생성된 문서 ID를 프로퍼티에 저장
    var folderDTO = FolderDTO(folder)
    folderDTO.id = folderDocRef.documentID
    
    /// 3. Firestore에 추가
    try folderDocRef.setData(from: folderDTO)
    
    /// 4. DocumentID가 업데이트 된 Folder Entity로 리턴
    return folderDTO.toEntity()
  }
  
  func fetchAllFolders() async throws -> [Folder] {
    /// 1. Folders 컬렉션 참조 생성
    // TODO: 후에 testUser를 실제 로그인 된 유저로 변경 예정
    let folderColRef = db.collection("users/testUser/folders")
    
    /// 2. 컬렉션의 모든 문서 가져오기
    let snapshot = try await folderColRef.getDocuments()
    
    /// 3. 문서를 DTO로 변환 후 다시 Entity로 변환
    return snapshot.documents.compactMap {
      try? $0.data(as: FolderDTO.self).toEntity()
    }
  }
  
  func updateFolder(_ folder: Folder) throws {
    /// 1. Folder 문서 참조 생성
    // TODO: 후에 testUser를 실제 로그인 된 유저로 변경 예정
    let folderDocRef = db.document("users/testUser/folders/\(folder.id)")
    
    /// 2. Entity를 DTO로 변환
    let folderDTO = FolderDTO(folder)
    
    /// 3. 업데이트
    try folderDocRef.setData(from: folderDTO)
  }
  
  func deleteFolder(_ folder: Folder) async throws {
    /// 1. Folder 문서 참조 생성
    // TODO: 후에 testUser를 실제 로그인 된 유저로 변경 예정
    let folderDocRef = db.document("users/testUser/folders/\(folder.id)")
    
    /// 2. Folder 삭제
    try await folderDocRef.delete()
  }
}
