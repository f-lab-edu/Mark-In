//
//  GenerateLinkUseCase.swift
//  Mark-In
//
//  Created by 이정동 on 5/11/25.
//

import Foundation

protocol GenerateLinkUseCase {
  func execute(writeLink: WriteLink) async throws -> Link
}
