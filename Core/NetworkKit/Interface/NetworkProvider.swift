//
//  NetworkProvider.swift
//  NetworkKitInterface
//
//  Created by 이정동 on 7/7/25.
//

import Foundation

public protocol NetworkProvider {
  func request<T: Decodable>(
    endpoint: APIEndpoint,
    type: T.Type
  ) async throws -> T
  
  func requestString(
    endpoint: APIEndpoint,
    encoding: String.Encoding
  ) async throws -> String
}
