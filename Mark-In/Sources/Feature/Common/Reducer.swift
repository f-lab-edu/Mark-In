//
//  Reducer.swift
//  Mark-In
//
//  Created by 이정동 on 4/25/25.
//

import Foundation

@MainActor
protocol Reducer {
  associatedtype State
  associatedtype Action
  
  func send(_ action: Action)
  
  func reduce(state: inout State, action: Action) -> Effect<Action>
}

enum Effect<Action> {
  case none
  case run(() async -> Action)
}
