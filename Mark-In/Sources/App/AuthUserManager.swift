//
//  AuthManager.swift
//  Mark-In
//
//  Created by 이정동 on 5/8/25.
//

// TODO: Core 모듈로 이전 예정

import Foundation

import Util

struct AuthUser: Codable {
  let id: String
  let name: String
  let email: String
  let provider: SocialSignInProvider
}

protocol AuthUserManager {
  var user: AuthUser? { get }
  
  func save(_ user: AuthUser)
  func load()
  func clear()
}

@Observable
final class AuthUserManagerImpl: AuthUserManager {
  
  private let keychainStore: KeychainStore
  
  var user: AuthUser?
  
  init(keychainStore: KeychainStore) {
    self.keychainStore = keychainStore
    self.load()
  }
  
  func load() {
    let user: AuthUser? = try? keychainStore.load(forKey: "authUser")
    self.user = user
  }
  
  func save(_ user: AuthUser) {
    try? keychainStore.save(user, forKey: "authUser")
    self.user = user
  }
  
  func clear() {
    try? keychainStore.delete(forKey: "authUser")
    user = nil
  }
}

enum AuthError: Error {
  case unauthenticated
}
