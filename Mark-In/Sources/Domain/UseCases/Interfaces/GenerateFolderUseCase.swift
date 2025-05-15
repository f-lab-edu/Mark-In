//
//  GenerateFolderUseCase.swift
//  Mark-In
//
//  Created by 이정동 on 5/8/25.
//

import Foundation

protocol GenerateFolderUseCase {
  func execute(writeFolder: WriteFolder) async throws -> Folder
}
