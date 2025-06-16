//
//  DeleteFolderUseCase.swift
//  Mark-In
//
//  Created by 이정동 on 6/3/25.
//

import Foundation

protocol DeleteFolderUseCase {
  func execute(folderID: String?, includingChildren: Bool) async throws
}
