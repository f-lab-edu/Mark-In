//
//  APIEndpoint.swift
//  NetworkKit
//
//  Created by 이정동 on 7/7/25.
//

import Foundation

public protocol APIEndpoint {
  var baseURL: URL { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var task: HTTPTask { get }
  var headers: [String: String]? { get }
}
