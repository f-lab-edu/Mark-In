//
//  FetchFolderListUseCase.swift
//  Mark-In
//
//  Created by 이정동 on 5/11/25.
//

import Foundation

protocol FetchFolderListUseCase {
  func execute(userID: String) async throws -> [Folder]
}
