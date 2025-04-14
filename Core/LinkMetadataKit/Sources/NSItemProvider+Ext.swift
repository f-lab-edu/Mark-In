//
//  NSItemProvider+Ext.swift
//  LinkMetadataKit
//
//  Created by 이정동 on 4/14/25.
//

import Foundation
import UniformTypeIdentifiers

extension NSItemProvider {
  func loadDataRepresentation(for type: UTType) async throws -> Data? {
    try await withCheckedThrowingContinuation { continuation in
      _ = loadDataRepresentation(for: type) { data, error in
        if let error { continuation.resume(throwing: error) }
        
        continuation.resume(returning: data)
      }
    }
  }
}
