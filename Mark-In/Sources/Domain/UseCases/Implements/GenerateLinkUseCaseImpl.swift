//
//  GenerateLinkUseCaseImpl.swift
//  Mark-In
//
//  Created by 이정동 on 5/11/25.
//

import Foundation

struct GenerateLinkUseCaseImpl: GenerateLinkUseCase {
  
  private let linkRepository: LinkRepository
  
  init(linkRepository: LinkRepository) {
    self.linkRepository = linkRepository
  }
  
  func execute(writeLink: WriteLink) async throws -> WebLink {
    
    // TODO: #29번 PR 머지 후 AuthManager를 통해 현재 로그인 유저 정보 가져옴
    let user = "testUser"
    
    let newLink = try await linkRepository.create(userID: user, link: writeLink)
    return newLink
  }
}
