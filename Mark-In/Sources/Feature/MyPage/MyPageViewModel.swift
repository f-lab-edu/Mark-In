//
//  MyPageViewModel.swift
//  Mark-In
//
//  Created by 이정동 on 5/13/25.
//

import Foundation

import FirebaseAuth
import GoogleSignIn

@Observable
final class MyPageViewModel: Reducer {
  struct State {
    var userState: AuthUserState = .init()
  }
  
  enum Action {
    case logoutButtonTapped
    case withdrawalButtonTapped
    
    case didSuccessLogout
    case didFailLogout
    
    case didSuccessWithdrawal
    case didFailWithdrawal
  }
  
  private let authUserManager: AuthUserManager
  
  private(set) var state: State = .init()
  
  init() {
    self.authUserManager = DIContainer.shared.resolve()
  }
  
  func send(_ action: Action) {
    let effect = reduce(state: &state, action: action)
    handleEffect(effect)
  }
  
  func reduce(state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .logoutButtonTapped:
      return .run {
        // TODO: 이후 Auth 모듈로 분리하면서 코드 리팩토링 예정
        do {
          try Auth.auth().signOut()
          
          if GIDSignIn.sharedInstance.currentUser != nil {
            GIDSignIn.sharedInstance.signOut()
          }
          return .didSuccessLogout
        } catch {
          return .didFailLogout
        }
      }
      
    case .withdrawalButtonTapped:
      return .run {
        // TODO: 이후 Auth 모듈로 분리하면서 코드 리팩토링 예정
        do {
          // TODO: 재인증 과정 필요
          // try await Auth.auth().currentUser?.reauthenticate(with: credential)
          try await Auth.auth().currentUser?.delete()
          
          if GIDSignIn.sharedInstance.currentUser != nil {
            try await GIDSignIn.sharedInstance.disconnect()
            GIDSignIn.sharedInstance.signOut()
          }
          
          return .didSuccessWithdrawal
        } catch {
          return .didFailWithdrawal
        }
      }
      
    case .didSuccessLogout:
      authUserManager.clear()
      return .none
      
      // TODO: 로그아웃 실패에 대한 처리 필요
    case .didFailLogout:
      return .none
      
    case .didSuccessWithdrawal:
      authUserManager.clear()
      return .none
      
      // TODO: 회원탈퇴 실패에 대한 처리 필요
    case .didFailWithdrawal:
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

extension MyPageViewModel {
  struct AuthUserState {
    var name: String = ""
    var email: String = ""
  }
}
