//
//  SignInUseCaseImpl.swift
//  Mark-In
//
//  Created by 이정동 on 5/15/25.
//

import Foundation

import FirebaseAuth

import NetworkKitInterface
import Util

struct SignInUseCaseImpl: SignInUseCase {
  
  private let keychainStore: KeychainStore
  private let authUserManager: AuthUserManager
  private let networkProvider: NetworkProvider
  
  init(
    keychainStore: KeychainStore,
    authUserManager: AuthUserManager,
    networkProvider: NetworkProvider
  ) {
    self.keychainStore = keychainStore
    self.authUserManager = authUserManager
    self.networkProvider = networkProvider
  }
  
  func execute(using info: AppleSignInInfo) async throws {
    /// 애플 로그인 정보에 필요한 정보들이 누락되는 경우
    guard let nonce = info.nonce,
          let appleIDToken = info.idCredential.identityToken,
          let idTokenString = String(data: appleIDToken, encoding: .utf8),
          let authorizationCode = info.idCredential.authorizationCode,
          let codeString = String(data: authorizationCode, encoding: .utf8) else {
      throw SignInError.missingData
    }
    
    
    let refreshToken = try await networkProvider.requestString(
      endpoint: AppleAuthAPI.refreshToken(code: codeString),
      encoding: .utf8
    )
    
    /// Refresh Token 저장
    try keychainStore.save(refreshToken, forKey: .refreshToken)
      
    /// Firebase 인증 요청을 위한 AuthCredential 생성
    let credential = OAuthProvider.appleCredential(
      withIDToken: idTokenString,
      rawNonce: nonce,
      fullName: info.idCredential.fullName
    )
    
    /// Firebase 인증 요청
    let response = try await Auth.auth().signIn(with: credential)
    
    /// AuthUserManager에 유저 데이터 저장
    let authUser = AuthUser(
      id: response.user.uid,
      name: response.user.displayName ?? "-",
      email: response.user.email ?? "-",
      provider: .apple
    )
    authUserManager.save(authUser)
  }
  
  func execute(using info: GoogleSignInInfo) async throws {
    /// 로그인에 필요한 정보(IDToken)가 누락된 경우
    guard let idToken = info.user.idToken?.tokenString else {
      throw SignInError.missingData
    }
    
    // TODO: 아래 코드들을 Core(Auth) 모듈에서 처리하도록 리팩토링
    /// Firebase 인증 요청을 위한 AuthCredential 생성
    let credential = GoogleAuthProvider.credential(
      withIDToken: idToken,
      accessToken: info.user.accessToken.tokenString
    )
    
    /// Firebase 인증 요청
    let response = try await Auth.auth().signIn(with: credential)
    
    /// AuthUserManager에 유저 데이터 저장
    let authUser = AuthUser(
      id: response.user.uid,
      name: response.user.displayName ?? "-",
      email: response.user.email ?? "-",
      provider: .google
    )
    authUserManager.save(authUser)
  }
}

