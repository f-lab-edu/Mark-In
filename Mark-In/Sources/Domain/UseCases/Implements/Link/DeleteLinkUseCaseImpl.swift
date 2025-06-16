//
//  DeleteLinkUseCaseImpl.swift
//  Mark-In
//
//  Created by 이정동 on 6/3/25.
//

import Foundation

struct DeleteLinkUseCaseImpl: DeleteLinkUseCase {
  
  private let authUserManager: AuthUserManager
  private let linkRepository: LinkRepository
  
  init(authUserManager: AuthUserManager, linkRepository: LinkRepository) {
    self.authUserManager = authUserManager
    self.linkRepository = linkRepository
  }
  
  func execute(linkID: String) async throws {
    guard let userID = authUserManager.user?.id else {
      throw AuthError.unauthenticated
    }
    
    try await linkRepository.delete(userID: userID, linkID: linkID)
  }
}
