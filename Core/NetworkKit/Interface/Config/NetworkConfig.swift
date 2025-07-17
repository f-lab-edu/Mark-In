//
//  NetworkConfig.swift
//  NetworkKitInterface
//
//  Created by 이정동 on 7/16/25.
//

import Foundation

struct NetworkConfig {
  private static let bundle: Bundle? = {
    let identifier = "kr.co.ios.swift.apple.NetworkKitInterface"
    return .init(identifier: identifier)
  }()
  
  static let refreshTokenBaseURL = bundle?.infoDictionary?["GetRefreshTokenURL"] as? String ?? ""
  static let revokeTokenBaseURL = bundle?.infoDictionary?["RevokeTokenURL"] as? String ?? ""
}
