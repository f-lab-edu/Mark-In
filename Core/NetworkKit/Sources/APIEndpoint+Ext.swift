//
//  APIEndpoint+Ext.swift
//  NetworkKitInterface
//
//  Created by 이정동 on 7/7/25.
//

import Foundation

import NetworkKitInterface

extension APIEndpoint {
  func asURLRequest() -> URLRequest? {
    
    /// Full URL Path 설정
    guard var urlComponents = URLComponents(
      url: baseURL.appending(path: path),
      resolvingAgainstBaseURL: true
    ),
          let url = urlComponents.url else { return nil }
    
    /// URLRequest 객체 생성
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = method.rawValue
    urlRequest.allHTTPHeaderFields = headers ?? urlRequest.allHTTPHeaderFields
    
    /// 요청 작업 별 설정
    switch self.task {
    case .requestPlain:
      break
    case let .requestQueryParameters(parameter):
      let queryItems: [URLQueryItem] = parameter.compactMap {
        guard let value = $0.value as? String else { return nil }
        return URLQueryItem(name: $0.key, value: value)
      }
      urlComponents.queryItems = urlComponents.queryItems.map { $0 + queryItems } ?? queryItems
      urlRequest.url = urlComponents.url
    @unknown default:
      break
    }
    
    return urlRequest
  }
}
