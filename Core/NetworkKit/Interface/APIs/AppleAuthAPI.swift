//
//  AppleAuthAPI.swift
//  NetworkKitInterface
//
//  Created by 이정동 on 7/15/25.
//

import Foundation

public enum AppleAuthAPI {
  case refreshToken(code: String)
  case revokeToken(token: String)
}

extension AppleAuthAPI: APIEndpoint {
  public var baseURL: URL {
    switch self {
    case .refreshToken:
      URL(string: NetworkConfig.refreshTokenBaseURL)!
    case .revokeToken:
      URL(string: NetworkConfig.revokeTokenBaseURL)!
    }
  }
  
  public var path: String {
    switch self {
    case .refreshToken:
      "/getRefreshToken"
    case .revokeToken:
      "/revokeToken"
    }
  }
  
  public var method: HTTPMethod { .get }
  
  public var task: HTTPTask {
    switch self {
    case .refreshToken(let code):
        .requestQueryParameters(parameters: [
          "code": code
        ])
    case .revokeToken(let token):
        .requestQueryParameters(parameters: [
          "refresh_token": token
        ])
    }
  }
  
  public var headers: [String : String]? {
    [
      "accept": "application/json"
    ]
  }
}
