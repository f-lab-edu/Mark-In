//
//  AppleAuthAPI.swift
//  NetworkKitInterface
//
//  Created by 이정동 on 7/15/25.
//

import Foundation

public enum AppleAuthAPI {
  case refreshToken
  case revokeToken
}

extension AppleAuthAPI: APIEndpoint {
  public var baseURL: URL {
    switch self {
    case .refreshToken:
      URL(string: "https://www.naver.com")!
    case .revokeToken:
      URL(string: "https://www.google.com")!
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
    case .refreshToken:
        .requestQueryParameters(parameters: [
          "code": "apikey"
        ])
    case .revokeToken:
        .requestQueryParameters(parameters: [
          "refresh_token": "key"
        ])
    }
  }
  
  public var headers: [String : String]? {
    [
      "accept": "application/json"
    ]
  }
}
