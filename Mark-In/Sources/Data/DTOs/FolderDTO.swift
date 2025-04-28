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
  var createdBy: Date
  
  init(_ folder: Folder) {
    self.id = folder.id
    self.name = folder.name
    self.createdBy = folder.createdBy
  }
  
  func toEntity() -> Folder {
    return Folder(
      id: self.id,
      name: self.name,
      createdBy: self.createdBy
    )
  }
}
