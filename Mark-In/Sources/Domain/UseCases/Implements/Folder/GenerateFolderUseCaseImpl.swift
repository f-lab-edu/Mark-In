//
//  GenerateFolderUseCaseImpl.swift
//  Mark-In
//
//  Created by 이정동 on 5/8/25.
//

import Foundation

struct GenerateFolderUseCaseImpl: GenerateFolderUseCase {
  
  private let authUserManager: AuthUserManager
  private let folderRepository: FolderRepository
  
  init(
    authUserManager: AuthUserManager,
    folderRepository: FolderRepository
  ) {
    self.authUserManager = authUserManager
    self.folderRepository = folderRepository
  }
  
  func execute(writeFolder: WriteFolder) async throws -> Folder {
    
    guard let user = authUserManager.user else { throw AuthError.unauthenticated }
    
    let newFolder = try await folderRepository.create(userID: user.id, folder: writeFolder)
    return newFolder
  }
}
