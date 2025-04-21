//
//  LinkRepositoryImpl.swift
//  Mark-In
//
//  Created by 이정동 on 4/21/25.
//

import Foundation

import FirebaseFirestore

struct LinkRepositoryImpl: LinkRepository {
  
  private let db = Firestore.firestore()
  
  func createLink(_ link: Link) throws -> Link {
    /// 1. Link 문서 참조 생성
    // TODO: 후에 testUser를 실제 로그인 된 유저로 변경 예정
    let linkDocRef = db.collection("users/testUser/links").document()
    
    /// 2. Entity를 DTO로 변환 및 새로 생성된 문서 ID를 프로퍼티에 저장
    var linkDTO = LinkDTO(link)
    linkDTO.id = linkDocRef.documentID
    
    /// 3. Firestore에 추가
    try linkDocRef.setData(from: linkDTO)
    
    /// 4. DocumentID 업데이트 된 LinkEntity로 리턴
    return linkDTO.toEntity()
  }
  
  func fetchAllLinks() async throws -> [Link] {
    /// 1. Links 컬렉션 참조 생성
    // TODO: 후에 testUser를 실제 로그인 된 유저로 변경 예정
    let linkColRef = db.collection("users/testUser/links")
    
    /// 2. 컬렉션의 모든 문서 가져오기
    let snapshot = try await linkColRef.getDocuments()
    
    /// 3. 문서를 DTO로 변환 후 다시 Entity로 변환
    return snapshot.documents.compactMap {
      try? $0.data(as: LinkDTO.self).toEntity()
    }
  }
  
  func updateLink(_ link: Link) throws {
    /// 1. Link 문서 참조 생성
    // TODO: 후에 testUser를 실제 로그인 된 유저로 변경 예정
    let linkDocRef = db.document("users/testUser/links/\(link.id)")
    
    /// 2. Entity를 DTO로 변환
    let linkDTO = LinkDTO(link)
    
    /// 3. 업데이트
    try linkDocRef.setData(from: linkDTO)
  }
  
  func deleteLink(_ link: Link) async throws {
    /// 1. Link 문서 참조 생성
    // TODO: 후에 testUser를 실제 로그인 된 유저로 변경 예정
    let linkDocRef = db.document("users/testUser/links/\(link.id)")
    
    /// 2. Link 삭제
    try await linkDocRef.delete()
  }
}
