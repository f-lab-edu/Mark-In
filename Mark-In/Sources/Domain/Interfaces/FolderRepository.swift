//
//  FolderRepository.swift
//  Mark-In
//
//  Created by 이정동 on 4/21/25.
//

import Foundation

protocol FolderRepository {
  func create(userID: String, folder: WriteFolder) async throws -> Folder
  func fetchAll(userID: String) async throws -> [Folder]
  func update(userID: String, folder: Folder) async throws
  func delete(userID: String, folderID: String) async throws
  func deleteAll(userID: String) async throws
}
