//
//  AuthManager.swift
//  Mark-In
//
//  Created by 이정동 on 5/8/25.
//

// TODO: Core 모듈로 이전 예정

import Combine
import Foundation

import FirebaseAuth

struct UserModel {
  let id: String
}

protocol AuthManager {
  var userEvent: PassthroughSubject<UserModel?, Never> { get }
  
  func checkLoginStatus()
  func setCurrentUser(id: String)
  func clearCurrentUser()
}

final class AuthManagerImpl: AuthManager {
  var userEvent: PassthroughSubject<UserModel?, Never> = .init()
  
  private var currentUser: UserModel?
  
  func checkLoginStatus() {
    if let user = Auth.auth().currentUser {
      setCurrentUser(id: user.uid)
    } else {
      clearCurrentUser()
    }
  }
  
  func setCurrentUser(id: String) {
    let user = UserModel(id: id)
    userEvent.send(user)
    currentUser = user
  }
  
  func clearCurrentUser() {
    userEvent.send(nil)
    currentUser = nil
  }
}
