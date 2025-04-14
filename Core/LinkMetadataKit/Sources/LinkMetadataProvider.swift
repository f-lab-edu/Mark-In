//
//  LinkMetadataProvider.swift
//  LinkMetadataProvider
//
//  Created by 이정동 on 4/8/25.
//

import Foundation
import LinkPresentation

import LinkMetadataKitInterface

public struct LinkMetadataProviderImpl: LinkMetadataProvider {
  private let metadataProvider = LPMetadataProvider()
  
  public init() {}
  
  public func fetchMetadata(urlString: String) async -> Result<LinkMetadata, LinkMetadataError> {
    /// URL 인코딩
    guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
          let url = URL(string: encoded)
    else { return .failure(.urlEncodingFailed) }
    
    /// 메타데이터 요청
    let metadata: LPLinkMetadata
    do {
      metadata = try await metadataProvider.startFetchingMetadata(for: url)
    } catch {
      return .failure(.concurrentFetchNotAllowed)
    }
    
    /// 파비콘 및 썸네일 리소스 로딩
    do {
      let favicon = try await metadata.iconProvider?.loadDataRepresentation(for: .image)
      let thumbnail = try await metadata.imageProvider?.loadDataRepresentation(for: .image)
      
      return .success(LinkMetadata(
        url: url.absoluteString,
        title: metadata.title,
        favicon: favicon,
        thumbnail: thumbnail
      ))
    } catch {
      return .failure(.resourceLoadFailed)
    }
  }
}



