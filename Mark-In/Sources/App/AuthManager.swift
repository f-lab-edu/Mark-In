//
//  AuthManager.swift
//  Mark-In
//
//  Created by 이정동 on 5/8/25.
//

// TODO: Core 모듈로 이전 예정

import Foundation

import FirebaseAuth

struct UserModel {
  let id: String
}

protocol AuthManager {
  var user: UserModel? { get }
  
  func saveUser(id: String)
  func clear()
}

@Observable
final class AuthManagerImpl: AuthManager {
  var user: UserModel?
  
  init() {
    guard let currentUser = Auth.auth().currentUser else { return }
    self.user = UserModel(id: currentUser.uid)
  }
  
  func saveUser(id: String) {
    let user = UserModel(id: id)
    self.user = user
  }
  
  func clear() {
    user = nil
  }
}
