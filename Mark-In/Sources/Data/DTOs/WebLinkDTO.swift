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
  
  var documentData: [String: Any] {
    [
      "id": self.id,
      "url": self.url,
      "title": self.title ?? NSNull(),
      "thumbnailUrl": self.thumbnailUrl ?? NSNull(),
      "faviconUrl": self.faviconUrl ?? NSNull(),
      "isPinned": self.isPinned,
      "createdAt": self.createdAt,
      "lastAccessedAt": self.lastAccessedAt ?? NSNull(),
      "folderID": self.folderID ?? NSNull(),
    ]
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
