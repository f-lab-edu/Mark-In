//
//  AuthManager.swift
//  Mark-In
//
//  Created by 이정동 on 5/8/25.
//

// TODO: Core 모듈로 이전 예정

import Foundation

import FirebaseAuth

struct AuthUser {
  let id: String
}

protocol AuthUserManager {
  var user: AuthUser? { get }
  
  func saveUser(id: String)
  func clear()
}

@Observable
final class AuthUserManagerImpl: AuthUserManager {
  var user: AuthUser?
  
  init() {
    guard let currentUser = Auth.auth().currentUser else { return }
    self.user = AuthUser(id: currentUser.uid)
  }
  
  func saveUser(id: String) {
    let user = AuthUser(id: id)
    self.user = user
  }
  
  func clear() {
    user = nil
  }
}
