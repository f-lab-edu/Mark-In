//
//  WithdrawalUseCase.swift
//  Mark-In
//
//  Created by 이정동 on 5/15/25.
//

import Foundation

enum WithdrawalError: Error {
  case credentialTooOld
}

protocol WithdrawalUseCase {
  func execute() async throws
}
