//
//  LoginViewModel.swift
//  Mark-In
//
//  Created by 이정동 on 5/1/25.
//

import Foundation
import AuthenticationServices
import SwiftUI

import FirebaseAuth
import GoogleSignIn

import Util

@Observable
final class LoginViewModel: Reducer {
  struct State {
    // TODO: 로그인 실패 시 알림 화면을 보여줄 상태 구현 생각 중
  }
  
  enum Action {
    case appleLoginButtonTapped(AuthorizationController)
    case googleLoginButtonTapped
    
    case signInError(SignInError)
    
    case firebaseAuthRequest(AuthCredential)
    case firebaseAuthResponse(Result<String, Error>)
    
    case empty
  }
  
  private(set) var state: State = .init()
  private let authUserManager: AuthUserManager
  
  init() {
    self.authUserManager = DIContainer.shared.resolve()
  }
  
  func send(_ action: Action) {
    let effect = reduce(state: &state, action: action)
    handleEffect(effect)
  }
  
  func reduce(state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .appleLoginButtonTapped(let authController):
      /// 1. 애플 로그인 요청을 위한 객체 생성
      let requestProvider = SignInWithAppleRequestProvider()
      let request = requestProvider.makeRequest()
      
      /// 2. 애플 로그인 인증 요청
      return .run { [nonce = requestProvider.currentNonce] in
        
        /// 중간에 로그인을 취소하거나, 애플 로그인 인증 방식이 아닌 경우는 빈 액션 반환
        /// (에러 상황은 아니기 때문에 어떠한 액션을 던질 필요가 없음)
        guard let result = try? await authController.performRequest(request),
              case let .appleID(idCredential) = result else { return .empty }
        
        /// 애플 로그인 정보에 필요한 정보들이 누락되는 경우
        guard let nonce,
              let appleIDToken = idCredential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
          return .signInError(.missingData)
        }
        
        /// Firebase 인증 요청을 위한 AuthCredential 생성
        let credential = OAuthProvider.appleCredential(
          withIDToken: idTokenString,
          rawNonce: nonce,
          fullName: idCredential.fullName
        )
        
        return .firebaseAuthRequest(credential)
      }
      
    case .googleLoginButtonTapped:

      guard let windowScene = NSApplication.shared.windows.first else {
        return .none
      }
      
      return .run {
        do {
          /// 구글 로그인 요청
          let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: windowScene)
          
          /// 로그인에 필요한 정보(IDToken)가 누락된 경우
          guard let idToken = result.user.idToken?.tokenString else {
            return .signInError(.missingData)
          }
          
          /// Firebase 인증 요청을 위한 AuthCredential 생성
          let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: result.user.accessToken.tokenString
          )
          
          return .firebaseAuthRequest(credential)
        } catch {
          return .signInError(.invalid)
        }
      }
      
      // TODO: 에러 처리 필요
    case .signInError(_):
      return .none
      
      // TODO: 구글 로그인까지 구현 후 디테일 수정
    case .firebaseAuthRequest(let credential):
      return .run {
        do {
          /// Firebase 인증 요청
          let response = try await Auth.auth().signIn(with: credential)
          
          return .firebaseAuthResponse(.success(response.user.uid))
        } catch {
          return .firebaseAuthResponse(.failure(error))
        }
      }

    case .firebaseAuthResponse(let result):
      switch result {
      case .success(let id):
        let user = AuthUser(id: id)
        authUserManager.saveUser(user)
      case .failure(let error):
        // TODO: 에러 처리 필요
        let _ = error as? AuthErrorCode
        break
      }
      return .none
      
    case .empty:
      return .none
    }
  }
  
  private func handleEffect(_ effect: Effect<Action>) {
    switch effect {
    case .none:
      break
    case .run(let action):
      Task.detached { [weak self] in
        let newAction = await action()
        await self?.send(newAction)
      }
    }
  }
}

extension LoginViewModel {
  enum SignInError: Error {
    case missingData
    case invalid
  }
}
