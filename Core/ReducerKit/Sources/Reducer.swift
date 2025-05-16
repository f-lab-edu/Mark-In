//
//  ReducerKit.swift
//  ReducerKit
//
//  Created by 이정동 on 5/16/25.
//

import Foundation

/// 액션에 따른 상태 변화 로직의 역할을 담당하는 프로토콜
public protocol Reducer<State, Action> {
  /// View에 표시할 데이터를 정의
  associatedtype State
  
  /// View에서 발생할 수 있는 동작을 정의
  associatedtype Action
  
  /// 액션에 따라 기존 상태를 새로운 상태로 변경
  func reduce(into state: inout State, action: Action) -> Effect<Action>
}

