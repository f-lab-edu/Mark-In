//
//  URLConfigurable.swift
//  URLConfigurable
//
//  Created by 이정동 on 7/7/25.
//

import Foundation

public struct URLConfigurable {
  public let refreshTokenBaseURL: String
  public let revokeTokenBaseURL: String
  
  public init(refreshTokenBaseURL: String, revokeTokenBaseURL: String) {
    self.refreshTokenBaseURL = refreshTokenBaseURL
    self.revokeTokenBaseURL = revokeTokenBaseURL
  }
}
