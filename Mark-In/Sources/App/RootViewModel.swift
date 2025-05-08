//
//  RootViewModel.swift
//  Mark-In
//
//  Created by 이정동 on 5/5/25.
//

import Combine
import Foundation

@Observable
final class RootViewModel: Reducer {
  struct State {
    var isSplashVisible: Bool = true
    var currentUser: UserModel? = nil
  }
  
  enum Action {
    case onAppear
    case receiveCurrentUserEvent(UserModel?)
  }
  
  private let authManager: AuthManager
  
  private(set) var state: State = .init()
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    self.authManager = DIContainer.shared.resolve()
    
    self.authManager.userEvent
      .receive(on: RunLoop.main)
      .sink { [weak self] value in
        self?.send(.receiveCurrentUserEvent(value))
      }
      .store(in: &cancellables)
  }
  
  func send(_ action: Action) {
    let effect = reduce(state: &state, action: action)
    handleEffect(effect)
  }
  
  func reduce(state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      authManager.checkLoginStatus()
      return .none
    case .receiveCurrentUserEvent(let currentUser):
      state.currentUser = currentUser
      state.isSplashVisible = false
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
