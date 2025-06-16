//
//  LinkDTO.swift
//  Mark-In
//
//  Created by 이정동 on 4/20/25.
//

import Foundation

struct WebLinkDTO: Codable {
  var id: String
  var url: String
  var title: String?
  var thumbnailUrl: String?
  var faviconUrl: String?
  var isPinned: Bool
  var createdAt: Date
  var lastAccessedAt: Date?
  var folderID: String?
  
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case url = "url"
    case title = "title"
    case thumbnailUrl = "thumbnailUrl"
    case faviconUrl = "faviconUrl"
    case isPinned = "isPinned"
    case createdAt = "createdAt"
    case lastAccessedAt = "lastAccessedAt"
    case folderID = "folderID"
  }
  
  func toEntity() -> WebLink {
    WebLink(
      id: self.id,
      url: self.url,
      title: self.title,
      thumbnailUrl: self.thumbnailUrl,
      faviconUrl: self.faviconUrl,
      isPinned: self.isPinned,
      createdAt: self.createdAt,
      lastAccessedAt: self.lastAccessedAt,
      folderID: self.folderID
    )
  }
}
