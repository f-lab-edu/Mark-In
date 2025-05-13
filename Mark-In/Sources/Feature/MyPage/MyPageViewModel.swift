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
    
  }
  
  enum Action {
    case logoutButtonTapped
    case withdrawalButtonTapped
    
    case didSuccessLogout
    case didFailLogout
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
        // TODO: 이후 Auth 모듈을 분리하면서 코드 리팩토링 예정
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
      return .none
      
    case .didSuccessLogout:
      authUserManager.clear()
      return .none
      
      // TODO: 로그아웃 실패에 대한 처리 필요
    case .didFailLogout:
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
