//
//  FirestoreFieldKey.swift
//  Mark-In
//
//  Created by 이정동 on 6/4/25.
//

import Foundation

enum FirestoreFieldKey {
  enum Link {
    static let id = "id"
    static let url = "url"
    static let title = "title"
    static let thumbnailUrl = "thumbnailUrl"
    static let faviconUrl = "faviconUrl"
    static let isPinned = "isPinned"
    static let createdAt = "createdAt"
    static let lastAccessedAt = "lastAccessedAt"
    static let folderID = "folderID"
  }
  
  enum Folder {
    static let id = "id"
    static let name = "name"
    static let createdAt = "createdAt"
  }
}
