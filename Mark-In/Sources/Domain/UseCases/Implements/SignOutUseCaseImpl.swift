//
//  SignOutUseCaseImpl.swift
//  Mark-In
//
//  Created by 이정동 on 5/15/25.
//

import Foundation

import FirebaseAuth
import GoogleSignIn

struct SignOutUseCaseImpl: SignOutUseCase {
  
  private let authUserManager: AuthUserManager
  
  init(authUserManager: AuthUserManager) {
    self.authUserManager = authUserManager
  }
  
  func execute() throws {
    // TODO: Core(Auth) 모듈에서 처리하도록 리팩토링
    try Auth.auth().signOut()
    
    /// 구글 사용자인 경우
    if authUserManager.user?.provider == .google {
      GIDSignIn.sharedInstance.signOut()
    }
    
    authUserManager.clear()
  }
}
