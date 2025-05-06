//
//  FirebasePath.swift
//  Mark-In
//
//  Created by 이정동 on 4/30/25.
//

import Foundation

enum FirebasePath {
  case links(userID: String)
  case folders(userID: String)
  case thumbnails(userID: String)
  case favicons(userID: String)
  
  var path: String {
    switch self {
    case .links(let userID):
      "users/\(userID)/links"
    case .folders(let userID):
      "users/\(userID)/folders"
    case .thumbnails(let userID):
      "users/\(userID)/thumbnails"
    case .favicons(let userID):
      "users/\(userID)/favicons"
    }
  }
}
