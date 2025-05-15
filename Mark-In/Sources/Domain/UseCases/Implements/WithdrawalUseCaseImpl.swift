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
  
  init(keychainStore: KeychainStore, authUserManager: AuthUserManager) {
    self.keychainStore = keychainStore
    self.authUserManager = authUserManager
  }
  
  func execute() async throws {
    do {
      try await Auth.auth().currentUser?.delete()
    } catch {
      throw WithdrawalError.credentialTooOld
    }
    
    guard let provider = authUserManager.user?.provider else { return }
    
    switch provider {
    case .apple:
      let token: String? = try? keychainStore.load(forKey: "refreshToken")
      guard let token else { return }
      
      let url = URL(string: "https://\(Config.value(forKey: .revokeTokenURL))/revokeToken?refresh_token=\(token)"
        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
      
      _ = try await URLSession.shared.data(from: url)
      
      try keychainStore.delete(forKey: "refreshToken")
      
    case .google:
      try? await GIDSignIn.sharedInstance.disconnect()
      GIDSignIn.sharedInstance.signOut()
      
    @unknown default:
      fatalError("")
    }
    
    authUserManager.clear()
  }
}
