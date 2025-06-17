//
//  MockFolderRepository.swift
//  Mark-In
//
//  Created by 이정동 on 6/6/25.
//

@testable import Mark_In
import Foundation

final class FakeFolderRepository: FolderRepository {
  var data: [String: [Folder]] = [:]
  
  func create(userID: String, folder: WriteFolder) async throws -> Folder {
    let folder = Folder(
      id: UUID().uuidString,
      name: folder.name,
      createdAt: Date()
    )
    
    data[userID, default: []].append(folder)
    return folder
  }
  
  func fetchAll(userID: String) async throws -> [Folder] {
    return data[userID] ?? []
  }
  
  func delete(userID: String, folderID: String) async throws {
    data[userID]?.removeAll { $0.id == folderID }
  }
  
  func deleteAll(userID: String) async throws {
    data[userID] = []
  }
}

extension FakeFolderRepository {
  func withTestFolders(userID: String, count: Int) -> Self {
    let dummyFolders = (0..<count).map { _ in Folder.makeTestObject() }
    data[userID, default: []].append(contentsOf: dummyFolders)
    return self
  }
  
  func withTestFolder(userID: String, folderID: String?) -> Self {
    let dummyFolder = Folder.makeTestObject(id: folderID)
    data[userID, default: []].append(dummyFolder)
    return self
  }
}

private extension Folder {
  static func makeTestObject(
    id: String? = UUID().uuidString,
    name: String = "test-folder",
    createdAt: Date = Date()
  ) -> Folder {
    Folder(id: id, name: name, createdAt: createdAt)
  }
}
