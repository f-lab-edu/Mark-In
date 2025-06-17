//
//  MockLinkRepository.swift
//  Mark-In
//
//  Created by 이정동 on 6/6/25.
//

@testable import Mark_In
import Foundation

final class FakeLinkRepository: LinkRepository {
  
  var data: [String: [WebLink]] = [:]
  
  func create(userID: String, link: WriteLink) async throws -> WebLink {
    let webLink = WebLink(
      id: UUID().uuidString,
      url: link.url,
      title: link.title,
      thumbnailUrl: nil,
      faviconUrl: nil,
      isPinned: false,
      createdAt: Date(),
      lastAccessedAt: nil,
      folderID: link.folderID
    )
    
    data[userID, default: []].append(webLink)
    
    return webLink
  }
  
  func fetchAll(userID: String) async throws -> [WebLink] {
    return data[userID] ?? []
  }
  
  func moveLinkInFolder(userID: String, target linkID: String, to folderID: String?) async throws {
    let updated = data[userID]?.map {
      $0.id == linkID ? $0.updating(folderID: folderID) : $0
    }
    
    data[userID] = updated
  }
  
  func moveLinksInFolder(userID: String, fromFolderID: String?, toFolderID: String?) async throws {
    let updated = data[userID]?.map {
      $0.folderID == fromFolderID ? $0.updating(folderID: toFolderID) : $0
    }
    
    data[userID] = updated
  }
  
  func delete(userID: String, linkID: String) async throws {
    data[userID]?.removeAll { $0.id == linkID }
  }
  
  func deleteAllInFolder(userID: String, folderID: String?) async throws {
    data[userID]?.removeAll { $0.folderID == folderID }
  }
  
  func deleteAll(userID: String) async throws {
    data[userID] = []
  }
}

extension FakeLinkRepository {
  func withTestLinks(userID: String, folderID: String?, count: Int) -> Self {
    let testLinks = (0..<count).map { _ in WebLink.makeTestObject(folderID: folderID) }
    data[userID, default: []].append(contentsOf: testLinks)
    return self
  }
  
  func withTestLink(userID: String, linkID: String, folderID: String? = nil) -> Self {
    let testLink = WebLink.makeTestObject(id: linkID, folderID: folderID)
    data[userID, default: []].append(testLink)
    return self
  }
}

private extension WebLink {
  static func makeTestObject(
    id: String = UUID().uuidString,
    url: String = "https://example.com",
    title: String = "Test Link",
    thumbnailUrl: String? = nil,
    faviconUrl: String? = nil,
    isPinned: Bool = false,
    createdAt: Date = Date(),
    lastAccessedAt: Date? = nil,
    folderID: String? = "test-folder",
  ) -> WebLink {
    WebLink(
      id: id,
      url: url,
      title: title,
      thumbnailUrl: thumbnailUrl,
      faviconUrl: faviconUrl,
      isPinned: isPinned,
      createdAt: createdAt,
      lastAccessedAt: lastAccessedAt,
      folderID: folderID
    )
  }
  
  func updating(folderID: String?) -> WebLink {
    WebLink(
      id: id,
      url: url,
      title: title,
      thumbnailUrl: thumbnailUrl,
      faviconUrl: faviconUrl,
      isPinned: isPinned,
      createdAt: createdAt,
      lastAccessedAt: lastAccessedAt,
      folderID: folderID
    )
  }
}
