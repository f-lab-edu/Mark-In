//
//  RootViewModel.swift
//  Mark-In
//
//  Created by 이정동 on 5/5/25.
//

import Foundation

@Observable
final class RootViewModel: Reducer {
  struct State {
    var isSplashVisible: Bool = true
  }
  
  enum Action {
    case onAppear
  }
  
  private(set) var state: State = .init()
  private(set) var sharedState: AppState
  
  private let fetchCurrentUserIDUseCase: FetchCurrentUserIDUseCase
  
  init() {
    self.sharedState = DIContainer.shared.resolve()
    self.fetchCurrentUserIDUseCase = DIContainer.shared.resolve()
  }
  
  func send(_ action: Action) {
    let effect = reduce(state: &state, action: action)
    handleEffect(effect)
  }
  
  func reduce(state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      let uid = fetchCurrentUserIDUseCase.execute()
      state.isSplashVisible = false
      sharedState.isLoginned = uid != nil
      return .none
    }
  }
  
  private func handleEffect(_ effect: Effect<Action>) {
    switch effect {
    case .none:
      break
    case .run(let action):
      Task {
        let newAction = await action()
        send(newAction)
      }
    }
  }
}
