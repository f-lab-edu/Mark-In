//
//  AuthRepositoryImpl.swift
//  Mark-In
//
//  Created by 이정동 on 5/5/25.
//

import Foundation

import FirebaseAuth

struct AuthRepositoryImpl: AuthRepository {
  func fetchCurrentUserID() -> String? {
    let user = Auth.auth().currentUser
    return user?.uid
  }
}
