//
//  GenerateFolderUseCaseImpl.swift
//  Mark-In
//
//  Created by 이정동 on 5/8/25.
//

import Foundation

struct GenerateFolderUseCaseImpl: GenerateFolderUseCase {
  
  private let folderRepository: FolderRepository
  
  init(folderRepository: FolderRepository) {
    self.folderRepository = folderRepository
  }
  
  func execute(name: String) async throws -> Folder {
    let writeFolder = WriteFolder(name: name)
    
    // TODO: #29번 PR 머지 후 AuthManager를 통해 현재 로그인 유저 정보 가져옴
    let user = "123"
    
    let newFolder = try await folderRepository.create(userID: user, folder: writeFolder)
    return newFolder
  }
}
