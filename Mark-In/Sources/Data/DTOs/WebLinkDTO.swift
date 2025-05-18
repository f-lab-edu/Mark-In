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
  var createdBy: Date
  var lastAccessedAt: Date?
  var folderID: String?
  
  func toEntity() -> WebLink {
    WebLink(
      id: self.id,
      url: self.url,
      title: self.title,
      thumbnailUrl: self.thumbnailUrl,
      faviconUrl: self.faviconUrl,
      isPinned: self.isPinned,
      createdBy: self.createdBy,
      lastAccessedAt: self.lastAccessedAt,
      folderID: self.folderID
    )
  }
}
