//
//  FetchCurrentUserIDUseCaseImpl.swift
//  Mark-In
//
//  Created by 이정동 on 5/5/25.
//

import Foundation

struct FetchCurrentUserIDUseCaseImpl: FetchCurrentUserIDUseCase {
  
  private let authRepository: AuthRepository
  
  init(authRepository: AuthRepository) {
    self.authRepository = authRepository
  }
  
  func execute() -> String? {
    authRepository.fetchCurrentUserID()
  }
}
