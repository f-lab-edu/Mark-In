//
//  Reducer.swift
//  Mark-In
//
//  Created by 이정동 on 4/25/25.
//

import Foundation

protocol Reducer {
  associatedtype State
  associatedtype Action
  
  @MainActor
  func send(_ action: Action)
  
  @MainActor
  func reduce(state: inout State, action: Action) -> Effect<Action>
}

enum Effect<Action> {
  case none
  case run(() async -> Action)
}
