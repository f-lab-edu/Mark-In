//
//  NetworkError.swift
//  NetworkKitInterface
//
//  Created by 이정동 on 7/7/25.
//

import Foundation

public enum NetworkError: Error {
  case invalidURL
  case httpStatusError(Int)
  case urlSessionError(Error)
  case stringDecodingError
}
