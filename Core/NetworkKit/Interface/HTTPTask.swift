//
//  HTTPTask.swift
//  NetworkKitInterface
//
//  Created by 이정동 on 7/15/25.
//

import Foundation

public enum HTTPTask {
  case requestPlain
  case requestQueryParameters(parameters: [String: Any])
}
