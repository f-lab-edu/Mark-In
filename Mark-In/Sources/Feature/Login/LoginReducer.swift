//
//  LoginViewModel.swift
//  Mark-In
//
//  Created by 이정동 on 5/1/25.
//

import AuthenticationServices
import Foundation
import SwiftUI

import FirebaseAuth
import GoogleSignIn

import ReducerKit
import Util

struct LoginReducer: Reducer {
  struct State {
    // TODO: 로그인 실패 시 알림 화면을 보여줄 상태 구현 생각 중
  }
  
  enum Action {
    case appleLoginButtonTapped(AuthorizationController)
    case googleLoginButtonTapped
    
    case signInError
    
    case empty
  }
  
  private let signInUseCase: SignInUseCase
  
  init() {
    self.signInUseCase = DIContainer.shared.resolve()
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
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
        
        let appleSignInInfo = AppleSignInInfo(nonce: nonce, idCredential: idCredential)
        
        do {
          try await self.signInUseCase.signIn(using: appleSignInInfo)
          return .empty
        } catch {
          return .signInError
        }
      }
      
    case .googleLoginButtonTapped:
      
      guard let windowScene = NSApplication.shared.windows.first else {
        return .none
      }
      
      return .run {
        do {
          /// 구글 로그인 요청
          let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: windowScene)
          
          let googleSignInInfo = GoogleSignInInfo(user: result.user)
          try await self.signInUseCase.signIn(using: googleSignInInfo)
          
          return .empty
        } catch {
          return .signInError
        }
      }
      
      // TODO: 에러 처리 필요
    case .signInError:
      return .none
      
    case .empty:
      return .none
    }
  }
}
