//
//  FolderRepository.swift
//  Mark-In
//
//  Created by 이정동 on 4/21/25.
//

import Foundation

protocol FolderRepository {
  func createFolder(_ folder: Folder) async throws -> Folder
  func fetchAllFolders() async throws -> [Folder]
  func updateFolder(_ folder: Folder) async throws
  func deleteFolder(_ folder: Folder) async throws
}
