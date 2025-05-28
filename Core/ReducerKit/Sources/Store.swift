//
//  Store.swift
//  ReducerKit
//
//  Created by 이정동 on 5/16/25.
//

import Foundation

/// Reducer를 실행하고 UI를 업데이트하는 상태 관리자
@MainActor @Observable
public final class Store<R: Reducer> {
  
  public typealias State = R.State
  public typealias Action = R.Action
  
  private(set) public var state: State
  private let reduce: (inout State, Action) -> Effect<Action>
  
  public init(initialState: State, reducer: R) {
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
      return
    case let .run(action):
      Task.detached { [weak self] in
        guard let newAction = await action() else { return }
        await self?.send(newAction)
      }
    }
  }
}
