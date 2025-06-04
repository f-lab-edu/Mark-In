//
//  FetchFolderListUseCaseImpl.swift
//  Mark-In
//
//  Created by 이정동 on 5/11/25.
//

import Foundation

struct FetchFolderListUseCaseImpl: FetchFolderListUseCase {
  
  private let authUserManager: AuthUserManager
  private let folderRepository: FolderRepository
  
  init(
    authUserManager: AuthUserManager,
    folderRepository: FolderRepository
  ) {
    self.authUserManager = authUserManager
    self.folderRepository = folderRepository
  }
  
  func execute() async throws -> [Folder] {
    guard let user = authUserManager.user else { throw AuthError.unauthenticated }
    return try await folderRepository.fetchAll(userID: user.id)
  }
}
