//
//  FetchFolderListUseCaseImpl.swift
//  Mark-In
//
//  Created by 이정동 on 5/11/25.
//

import Foundation

struct FetchFolderListUseCaseImpl: FetchFolderListUseCase {
  
  private let folderRepository: FolderRepository
  
  init(folderRepository: FolderRepository) {
    self.folderRepository = folderRepository
  }
  
  func execute(userID: String) async throws -> [Folder] {
    try await folderRepository.fetchAll(userID: userID)
  }
}
