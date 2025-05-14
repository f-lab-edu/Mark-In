//
//  Config.swift
//  Mark-In
//
//  Created by 이정동 on 5/14/25.
//

import Foundation

struct Config {
  enum Key: String {
    case getRefreshTokenURL = "GetRefreshTokenURL"
    case revokeTokenURL = "RevokeTokenURL"
  }
  
  static func value(forKey: Self.Key) -> String {
    guard let value = Bundle.main.object(forInfoDictionaryKey: forKey.rawValue) as? String else {
      fatalError("\(forKey.rawValue) not set")
    }
    return value
  }
}
