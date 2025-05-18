//
//  FirebaseEndpoint.swift
//  Mark-In
//
//  Created by 이정동 on 4/30/25.
//

import Foundation

enum FirebaseEndpoint {
  enum FirestoreDB {
    case links(userID: String)
    case link(userID: String, linkID: String)
    case folders(userID: String)
    case folder(userID: String, folderID: String)
    
    var path: String {
      switch self {
      case .links(let userID):
        "users/\(userID)/links"
      case let .link(userID, linkID):
        "users/\(userID)/links/\(linkID)"
      case .folders(let userID):
        "users/\(userID)/folders"
      case let .folder(userID, folderID):
        "users/\(userID)/folders/\(folderID)"
      }
    }
  }
  
  enum Storage {
    case thumbnails(userID: String)
    case thumbnail(userID: String, thumbnailID: String)
    case favicons(userID: String)
    case favicon(userID: String, faviconID: String)
    
    var path: String {
      switch self {
      case .thumbnails(let userID):
        "users/\(userID)/thumbnails"
      case let .thumbnail(userID, thumbnailID):
        "users/\(userID)/thumbnails/\(thumbnailID)"
      case .favicons(let userID):
        "users/\(userID)/favicons"
      case let .favicon(userID, faviconID):
        "users/\(userID)/favicons/\(faviconID)"
      }
    }
  }
}
