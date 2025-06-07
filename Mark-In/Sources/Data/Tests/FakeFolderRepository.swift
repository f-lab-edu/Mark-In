//
//  MockFolderRepository.swift
//  Mark-In
//
//  Created by 이정동 on 6/6/25.
//

import Foundation

struct FakeFolderRepository: FolderRepository {
  func create(userID: String, folder: WriteFolder) async throws -> Folder {
    <#code#>
  }
  
  func fetchAll(userID: String) async throws -> [Folder] {
    <#code#>
  }
  
  func delete(userID: String, folderID: String) async throws {
    <#code#>
  }
  
  func deleteAll(userID: String) async throws {
    <#code#>
  }
}
