//
//  LinkMetadataProvider.swift
//  LinkMetadataProvider
//
//  Created by 이정동 on 4/8/25.
//

import Foundation
import LinkMetadataKitInterface

import LinkPresentation

public struct LinkMetadataProviderImpl: LinkMetadataProvider {
  private let metadataProvider = LPMetadataProvider()
  
  public init() {}
  
  public func fetchMetadata(urlString: String) async throws -> LinkMetadata {
    guard let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
          let url = URL(string: encoded)
    else { throw LinkMetadataError.urlEncodingFailed }
    
    let metadata = try await metadataProvider.startFetchingMetadata(for: url)
    
    do {
      let icon = try await metadata.iconProvider?.loadDataRepresentation(for: .image)
      let image = try await metadata.imageProvider?.loadDataRepresentation(for: .image)
      
      return LinkMetadata(
        url: url.absoluteString,
        title: metadata.title,
        icon: icon,
        image: image
      )
    } catch {
      throw LinkMetadataError.fetchFailed
    }
  }
}


