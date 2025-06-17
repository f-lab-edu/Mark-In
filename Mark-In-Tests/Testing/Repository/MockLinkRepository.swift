//
//  MockLinkRepository.swift
//  Mark-In-Tests
//
//  Created by 이정동 on 6/17/25.
//

import Foundation

final class MockLinkRepository: LinkRepository {
  
  var moveLinksInFolderCallCount: Int = 0
  var deleteAllInFolderCallCount: Int = 0
  
  func create(userID: String, link: WriteLink) async throws -> WebLink {
    return WebLink(id: "", url: "", isPinned: false, createdAt: Date())
  }
  
  func fetchAll(userID: String) async throws -> [WebLink] {
    return []
  }
  
  func moveLinkInFolder(userID: String, target linkID: String, to folderID: String?) async throws {
    
  }
  
  func moveLinksInFolder(userID: String, fromFolderID: String?, toFolderID: String?) async throws {
    moveLinksInFolderCallCount += 1
  }
  
  func delete(userID: String, linkID: String) async throws {
    
  }
  
  func deleteAllInFolder(userID: String, folderID: String?) async throws {
    deleteAllInFolderCallCount += 1
  }
  
  func deleteAll(userID: String) async throws {
    
  }
}
