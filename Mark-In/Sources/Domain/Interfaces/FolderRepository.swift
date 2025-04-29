//
//  FolderRepository.swift
//  Mark-In
//
//  Created by 이정동 on 4/21/25.
//

import Foundation

protocol FolderRepository {
  func create(_ folder: WriteFolder) async throws -> Folder
  func fetchAll() async throws -> [Folder]
  func update(_ folder: Folder) async throws
  func delete(_ folder: Folder) async throws
}
