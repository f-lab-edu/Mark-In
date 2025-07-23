//
//  LinkMetadataProviderImpl.swift
//  LinkMetadataProviderImpl
//
//  Created by 이정동 on 4/8/25.
//

import Foundation
import LinkPresentation

import LinkMetadataKitInterface

public struct LinkMetadataProviderImpl: LinkMetadataProvider {
  
  public init() {}
  
  public func fetchMetadata(urlString: String) async -> Result<LinkMetadata, LinkMetadataError> {
    let metadataProvider = LPMetadataProvider()
    
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
      async let favicon = await metadata.iconProvider?.loadDataRepresentation(for: .image)
      async let thumbnail = await metadata.imageProvider?.loadDataRepresentation(for: .image)
      
      let result = try await (favicon, thumbnail)
      
      return .success(LinkMetadata(
        url: url.absoluteString,
        title: metadata.title,
        favicon: result.0,
        thumbnail: result.1
      ))
    } catch {
      return .failure(.resourceLoadFailed)
    }
  }
}



