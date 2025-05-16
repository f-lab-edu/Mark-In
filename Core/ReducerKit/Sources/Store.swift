//
//  Store.swift
//  ReducerKit
//
//  Created by 이정동 on 5/16/25.
//

import Foundation

/// Store 타입을 좀 더 간편하게 정의(표현).
public typealias StoreOf<R: Reducer> = Store<R.State, R.Action>

/// Reducer를 실행하고 UI를 업데이트하는 상태 관리 라이프 사이클 관리자
@MainActor @Observable
public final class Store<State, Action> {
  
  private(set) public var state: State
  private let reduce: (inout State, Action) -> Effect<Action>
  
  // Reducer의 연관 타입 State, Action과 Store의 타입 파라미터 State, Action이 동일함을 표현
  public init<R: Reducer<State, Action>>(
    initialState: State,
    reducer: R
  ) {
    self.state = initialState
    self.reduce = reducer.reduce(into:action:)
  }
  
  // View로부터 Action을 전달 받아서 상태 업데이트
  public func send(_ action: Action) {
    let effect = reduce(&state, action)
    handleEffect(effect)
  }
  
  // reduce 작업 이후 추가적인 작업 실행
  private func handleEffect(_ effect: Effect<Action>) {
    switch effect {
    case .none:
      break
    case let .run(action):
      Task.detached { [weak self] in
        let newAction = await action()
        await self?.send(newAction)
      }
    }
  }
}
