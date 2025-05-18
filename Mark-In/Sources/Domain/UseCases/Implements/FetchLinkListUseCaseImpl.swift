//
//  FetchLinkListUseCaseImpl.swift
//  Mark-In
//
//  Created by 이정동 on 5/11/25.
//

import Foundation

struct FetchLinkListUseCaseImpl: FetchLinkListUseCase {
  
  private let linkRepository: LinkRepository
  
  init(linkRepository: LinkRepository) {
    self.linkRepository = linkRepository
  }
  
  func execute(userID: String) async throws -> [WebLink] {
    try await linkRepository.fetchAll(userID: userID)
  }
}
