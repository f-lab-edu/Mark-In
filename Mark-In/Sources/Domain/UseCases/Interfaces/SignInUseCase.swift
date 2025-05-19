//
//  SignInUseCase.swift
//  Mark-In
//
//  Created by 이정동 on 5/15/25.
//

import AuthenticationServices
import Foundation

import GoogleSignIn

import Util

enum SignInError: Error {
  case missingData
  case invalid
}

struct AppleSignInInfo {
  let nonce: String?
  let idCredential: ASAuthorizationAppleIDCredential
}

struct GoogleSignInInfo {
  let user: GIDGoogleUser
}

protocol SignInUseCase {
  func signIn(using info: AppleSignInInfo) async throws
  func signIn(using info: GoogleSignInInfo) async throws
}
