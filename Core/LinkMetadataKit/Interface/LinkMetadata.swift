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
  public let icon: Data?
  public let image: Data?
  
  public init(url: String, title: String?, icon: Data?, image: Data?) {
    self.url = url
    self.title = title
    self.icon = icon
    self.image = image
  }
}
