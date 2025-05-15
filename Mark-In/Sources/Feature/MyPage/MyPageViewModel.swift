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
    
    case didFailWithdrawal
    
    case empty
  }
  
  private let signOutUseCase: SignOutUseCase
  private let withdrawalUseCase: WithdrawalUseCase
  
  private(set) var state: State = .init()
  
  init() {
    self.signOutUseCase = DIContainer.shared.resolve()
    self.withdrawalUseCase = DIContainer.shared.resolve()
  }
  
  func send(_ action: Action) {
    let effect = reduce(state: &state, action: action)
    handleEffect(effect)
  }
  
  func reduce(state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .logoutButtonTapped:
      do {
        try signOutUseCase.execute()
      } catch {
        // TODO: 로그아웃 실패 처리 필요
      }
      return .none
      
    case .withdrawalButtonTapped:
      return .run {
        // TODO: 이후 Auth 모듈로 분리하면서 코드 리팩토링 예정
        do {
          try await self.withdrawalUseCase.execute()
          return .empty
        } catch {
          print(error.localizedDescription)
          return .didFailWithdrawal
        }
      }
      
      // TODO: 회원탈퇴 실패에 대한 처리 필요
    case .didFailWithdrawal:
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

extension MyPageViewModel {
  struct AuthUserState {
    var name: String = ""
    var email: String = ""
  }
}
