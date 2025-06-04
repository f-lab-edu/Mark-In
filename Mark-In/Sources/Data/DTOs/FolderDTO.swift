//
//  FolderDTO.swift
//  Mark-In
//
//  Created by 이정동 on 4/21/25.
//

import Foundation

struct FolderDTO: Codable {
  var id: String
  var name: String
  var createdAt: Date
  
  enum CodingKeys: String, CodingKey {
    case id = "id"
    case name = "name"
    case createdAt = "createdAt"
  }
  
  func toEntity() -> Folder {
    return Folder(
      id: self.id,
      name: self.name,
      createdAt: self.createdAt
    )
  }
}
