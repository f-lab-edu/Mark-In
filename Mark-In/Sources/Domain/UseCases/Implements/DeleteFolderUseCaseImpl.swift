//
//  DeleteFolderUseCaseImpl.swift
//  Mark-In
//
//  Created by 이정동 on 6/3/25.
//

import Foundation

struct DeleteFolderUseCaseImpl: DeleteFolderUseCase {
  
  private let authUserManager: AuthUserManager
  
  private let linkRepository: LinkRepository
  private let folderRepository: FolderRepository
  
  func execute(folderID: String?, includingChildren: Bool) async throws {
    guard let userID = authUserManager.user?.id else {
      throw AuthError.unauthenticated
    }
    
    /// 폴더 하위 데이터까지 삭제
    if includingChildren {
      try await linkRepository.deleteAllInFolder(userID: userID, folderID: folderID)
      
    /// 폴더 하위 데이터는 삭제하지 않음 -> 기본 폴더로 위치 변경시키기
    } else {
      try await linkRepository.moveLinksInFolder(
        userID: userID,
        fromFolderID: folderID,
        toFolderID: nil
      )
    }
    
    /// 폴더ID가 존재할 경우 (= 기본 폴더가 아닌 경우) 폴더 삭제
    if let folderID {
      try await folderRepository.delete(userID: userID, folderID: folderID)
    }
  }
}
