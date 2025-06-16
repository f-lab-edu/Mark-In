//
//  DeleteLinkUseCase.swift
//  Mark-In
//
//  Created by 이정동 on 6/3/25.
//

import Foundation

protocol DeleteLinkUseCase {
  func execute(linkID: String) async throws
}
