//
//  MockLinkRepository.swift
//  Mark-In
//
//  Created by 이정동 on 6/6/25.
//

import Foundation

final class FakeLinkRepository: LinkRepository {
  func create(userID: String, link: WriteLink) async throws -> WebLink {
    <#code#>
  }
  
  func fetchAll(userID: String) async throws -> [WebLink] {
    <#code#>
  }
  
  func moveLinkInFolder(userID: String, target linkID: String, to folderID: String?) async throws {
    <#code#>
  }
  
  func moveLinksInFolder(userID: String, fromFolderID: String?, toFolderID: String?) async throws {
    <#code#>
  }
  
  func delete(userID: String, linkID: String) async throws {
    <#code#>
  }
  
  func deleteAllInFolder(userID: String, folderID: String?) async throws {
    <#code#>
  }
  
  func deleteAll(userID: String) async throws {
    <#code#>
  }
  
  
}
