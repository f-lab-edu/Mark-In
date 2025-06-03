//
//  WithdrawalUseCaseImpl.swift
//  Mark-In
//
//  Created by 이정동 on 5/15/25.
//

import Foundation

import FirebaseAuth
import GoogleSignIn

struct WithdrawalUseCaseImpl: WithdrawalUseCase {
  
  private let keychainStore: KeychainStore
  private let authUserManager: AuthUserManager
  
  private let linkRepository: LinkRepository
  private let folderRepsoitory: FolderRepository
  
  init(
    keychainStore: KeychainStore,
    authUserManager: AuthUserManager,
    linkRepository: LinkRepository,
    folderRepsoitory: FolderRepository
  ) {
    self.keychainStore = keychainStore
    self.authUserManager = authUserManager
    self.linkRepository = linkRepository
    self.folderRepsoitory = folderRepsoitory
  }
  
  func execute() async throws {
    /// 현재 로그인 된 유저 상태 확인 후 인증 정보 삭제
    do {
      try await Auth.auth().currentUser?.delete()
    } catch {
      throw WithdrawalError.credentialTooOld
    }
    
    guard let user = authUserManager.user else { return }
    
    /// 사용자의 모든 데이터(링크, 폴더) 삭제
    try await withThrowingTaskGroup(of: Void.self) { group in
      group.addTask {
        try await linkRepository.deleteAll(userID: user.id)
      }
      
      group.addTask {
        try await folderRepsoitory.deleteAll(userID: user.id)
      }
      
      try await group.waitForAll()
    }
    
    /// OAuth 인증 해제
    switch user.provider {
    case .apple:
      try await revokeAppleAuthorization()
      
    case .google:
      try await revokeGoogleAuthorization()
      
    @unknown default:
      fatalError("Do not implement revoke function for provider: \(user.provider)")
    }
    
    authUserManager.clear()
  }
}

private extension WithdrawalUseCaseImpl {
  func revokeAppleAuthorization() async throws {
    let token: String? = try? keychainStore.load(forKey: .refreshToken)
    guard let token else { return }
    
    let url = URL(string: "https://\(Config.value(forKey: .revokeTokenURL))/revokeToken?refresh_token=\(token)"
      .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
    
    _ = try await URLSession.shared.data(from: url)
    
    try keychainStore.delete(forKey: .refreshToken)
  }
  
  func revokeGoogleAuthorization() async throws {
    try? await GIDSignIn.sharedInstance.disconnect()
    GIDSignIn.sharedInstance.signOut()
  }
}
