//
//  Link.swift
//  Mark-In
//
//  Created by 이정동 on 4/20/25.
//

import Foundation

struct Link {
  var id: String
  var url: String
  var title: String?
  var thumbnailUrl: String?
  var faviconUrl: String?
  var createdBy: Date
  var lastAccessedAt: Date?
  var folderId: String?
}
