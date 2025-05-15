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
    
    case didSuccessWithdrawal
    case didFailWithdrawal
  }
  
  private let signOutUseCase: SignOutUseCase
  private let authUserManager: AuthUserManager
  private let tokenStore: KeychainStore
  
  private(set) var state: State = .init()
  
  init() {
    self.signOutUseCase = DIContainer.shared.resolve()
    self.authUserManager = DIContainer.shared.resolve()
    self.tokenStore = KeychainStoreImpl()
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
          
          let token: String? = try? self.tokenStore.load(forKey: "refreshToken")
          guard let token else { return .didFailWithdrawal }
          
          let url = URL(string: "https://\(Config.value(forKey: .revokeTokenURL))/revokeToken?refresh_token=\(token)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
          
          _ = try await URLSession.shared.data(from: url)
          
          try self.tokenStore.delete(forKey: "refreshToken")
          
//          // TODO: 재인증 과정 필요
//          // try await Auth.auth().currentUser?.reauthenticate(with: credential)
//          try await Auth.auth().currentUser?.delete()
//          
//          if GIDSignIn.sharedInstance.currentUser != nil {
//            try await GIDSignIn.sharedInstance.disconnect()
//            GIDSignIn.sharedInstance.signOut()
//          }
//          
          return .didSuccessWithdrawal
        } catch {
          return .didFailWithdrawal
        }
      }
      
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
