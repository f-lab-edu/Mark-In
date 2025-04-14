//
//  LinkMetadataKitInterface.swift
//  LinkMetadataKitInterface
//
//  Created by 이정동 on 4/8/25.
//

import Foundation

public enum LinkMetadataError: Error {
  case urlEncodingFailed
  case concurrentFetchNotAllowed
  case resourceLoadFailed
}

public protocol LinkMetadataProvider {
  /// URL 주소를 기반으로 URL 메타데이터를 가져옵니다.
  /// - Parameter urlString: url 문자열
  /// - Returns: URL 메타데이터
  func fetchMetadata(urlString: String) async -> Result<LinkMetadata, LinkMetadataError>
}
