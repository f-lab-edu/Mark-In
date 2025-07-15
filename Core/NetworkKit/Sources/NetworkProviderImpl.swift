//
//  NetworkProviderImpl.swift
//  NetworkKit
//
//  Created by 이정동 on 7/7/25.
//

import Foundation

import NetworkKitInterface

public struct NetworkProviderImpl: NetworkProvider {
  
  private let session: URLSession
  private let urlConfigurable: URLConfigurable
  
  public init(
    session: URLSession = .shared,
    urlConfigurable: URLConfigurable
  ) {
    self.session = session
    self.urlConfigurable = urlConfigurable
  }
  
  public func request<T: Decodable>(endpoint: APIEndpoint, type: T) async throws -> T {
    let data = try await requestData(endpoint: endpoint)
    do {
      let decodedData = try JSONDecoder().decode(T.self, from: data)
      return decodedData
    } catch {
        throw NetworkError.stringDecodingError
    }
  }
  
  public func requestString(
    endpoint: APIEndpoint,
    encoding: String.Encoding
  ) async throws -> String {
    
    let data = try await requestData(endpoint: endpoint)
    guard let string = String(data: data, encoding: encoding) else {
      throw NetworkError.stringDecodingError
    }
    return string
  }
}

private extension NetworkProviderImpl {
  func requestData(endpoint: APIEndpoint) async throws -> Data {
    guard let request = endpoint.asURLRequest() else {
      throw NetworkError.invalidURL
    }
    
    do {
      let (data, response) = try await session.data(for: request)
      
      if let httpResponse = response as? HTTPURLResponse {
        guard 200...299 ~= httpResponse.statusCode else {
          throw NetworkError.httpStatusError(httpResponse.statusCode)
        }
      }
      
      return data
    } catch {
      throw NetworkError.urlSessionError(error)
    }
  }
}
