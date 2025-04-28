//
//  LinkMetadataKitInterface.swift
//  LinkMetadataKitInterface
//
//  Created by 이정동 on 4/8/25.
//

import Foundation

public struct LinkMetadata: Sendable {
  public let url: String
  public let title: String?
  public let favicon: Data?
  public let thumbnail: Data?
  
  public init(url: String, title: String?, favicon: Data?, thumbnail: Data?) {
    self.url = url
    self.title = title
    self.favicon = favicon
    self.thumbnail = thumbnail
  }
}
