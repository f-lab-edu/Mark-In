//
//  LinkRepository.swift
//  Mark-In
//
//  Created by 이정동 on 4/20/25.
//

import Foundation

protocol LinkRepository {
  func create(userID: String, link: WriteLink) async throws -> WebLink
  
  func fetchAll(userID: String) async throws -> [WebLink]
  
  func moveLinkInFolder(
    userID: String,
    target linkID: String,
    to folderID: String?
  ) async throws
  
  func moveLinksInFolder(
    userID: String,
    fromFolderID: String?,
    toFolderID: String?
  ) async throws
  
  
  func delete(userID: String, linkID: String) async throws
  func deleteAllInFolder(userID: String, folderID: String?) async throws
  func deleteAll(userID: String) async throws
}
