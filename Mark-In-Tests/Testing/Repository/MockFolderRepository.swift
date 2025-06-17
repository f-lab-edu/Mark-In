//
//  MockFolderRepository.swift
//  Mark-In-Tests
//
//  Created by 이정동 on 6/17/25.
//

import Foundation

final class MockFolderRepository: FolderRepository {
  
  var deleteCallCount: Int = 0
  
  func create(userID: String, folder: WriteFolder) async throws -> Folder {
    return Folder(name: "", createdAt: Date())
  }
  
  func fetchAll(userID: String) async throws -> [Folder] {
    return []
  }
  
  func delete(userID: String, folderID: String) async throws {
    deleteCallCount += 1
  }
  
  func deleteAll(userID: String) async throws {
    
  }
}
