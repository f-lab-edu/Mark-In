//
//  LinkDTO.swift
//  Mark-In
//
//  Created by 이정동 on 4/20/25.
//

import Foundation

struct LinkDTO: Codable {
  var id: String
  var url: String
  var title: String?
  var thumbnailUrl: String?
  var faviconUrl: String?
  var createdBy: Date
  var lastAccessedAt: Date?
  var folderId: String?
  
  init(_ link: Link) {
    self.id = link.id
    self.url = link.url
    self.title = link.title
    self.thumbnailUrl = link.thumbnailUrl
    self.faviconUrl = link.faviconUrl
    self.createdBy = link.createdBy
    self.lastAccessedAt = link.lastAccessedAt
    self.folderId = link.folderId
  }
  
  func toEntity() -> Link {
    Link(
      id: self.id,
      url: self.url,
      title: self.title,
      thumbnailUrl: self.thumbnailUrl,
      faviconUrl: self.faviconUrl,
      createdBy: self.createdBy,
      lastAccessedAt: self.lastAccessedAt,
      folderId: self.folderId
    )
  }
}
