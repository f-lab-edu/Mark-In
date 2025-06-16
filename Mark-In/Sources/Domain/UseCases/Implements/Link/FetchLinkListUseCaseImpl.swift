//
//  FetchLinkListUseCaseImpl.swift
//  Mark-In
//
//  Created by 이정동 on 5/11/25.
//

import Foundation

struct FetchLinkListUseCaseImpl: FetchLinkListUseCase {
  
  private let authUserManager: AuthUserManager
  private let linkRepository: LinkRepository
  
  init(
    authUserManager: AuthUserManager,
    linkRepository: LinkRepository
  ) {
    self.authUserManager = authUserManager
    self.linkRepository = linkRepository
  }
  
  func execute() async throws -> [WebLink] {
    guard let user = authUserManager.user else { throw AuthError.unauthenticated }
    return try await linkRepository.fetchAll(userID: user.id)
  }
}
