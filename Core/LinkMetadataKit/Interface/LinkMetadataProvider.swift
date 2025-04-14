//
//  LinkMetadataKitInterface.swift
//  LinkMetadataKitInterface
//
//  Created by 이정동 on 4/8/25.
//

import Foundation

public enum LinkMetadataError: Error {
  case urlEncodingFailed
  case fetchFailed
}

public protocol LinkMetadataProvider {
  func fetchMetadata(urlString: String) async throws -> LinkMetadata
}
