//
//  Effect.swift
//  ReducerKit
//
//  Created by 이정동 on 5/16/25.
//

import Foundation

/// Reducer가 처리한 결과로 발생시킬 수 있는 추가적인 작업
public enum Effect<Action> {
  /// 추가적인 작업을 실행하지 않음
  case none
  
  /// Side Effect를 처리하고, 새로운 Action을 호출
  case run(() async -> Action)
}
