//
//  GenerateLinkUseCaseImpl.swift
//  Mark-In
//
//  Created by 이정동 on 5/11/25.
//

import Foundation

struct GenerateLinkUseCaseImpl: GenerateLinkUseCase {
  
  private let authUserManager: AuthUserManager
  private let linkRepository: LinkRepository
  
  init(
    authUserManager: AuthUserManager,
    linkRepository: LinkRepository
  ) {
    self.authUserManager = authUserManager
    self.linkRepository = linkRepository
  }
  
  func execute(writeLink: WriteLink) async throws -> WebLink {
    
    guard let user = authUserManager.user else { throw AuthError.unauthenticated }
    
    let newLink = try await linkRepository.create(userID: user.id, link: writeLink)
    return newLink
  }
}
