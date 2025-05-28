//
//  MyPageViewModel.swift
//  Mark-In
//
//  Created by 이정동 on 5/13/25.
//

import Foundation

import FirebaseAuth
import GoogleSignIn

import AppDI
import ReducerKit

struct MyPageReducer: Reducer {
  struct State {
    var userState: AuthUserState = .init()
  }
  
  enum Action {
    case logoutButtonTapped
    case withdrawalButtonTapped
    
    case didFailWithdrawal
  }
  
  @Dependency private var signOutUseCase: SignOutUseCase
  @Dependency private var withdrawalUseCase: WithdrawalUseCase
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .logoutButtonTapped:
      signOutUseCase.execute()
      return .none
      
    case .withdrawalButtonTapped:
      return .run {
        // TODO: 이후 Auth 모듈로 분리하면서 코드 리팩토링 예정
        do {
          try await self.withdrawalUseCase.execute()
          return nil
        } catch {
          return .didFailWithdrawal
        }
      }
      
      // TODO: 회원탈퇴 실패에 대한 처리 필요
    case .didFailWithdrawal:
      return .none
    }
  }
}

extension MyPageReducer {
  struct AuthUserState {
    var name: String = ""
    var email: String = ""
  }
}
