//
//  BaseTestCase.swift
//  TestSupport
//
//  Created by 이정동 on 6/6/25.
//

import Foundation

public protocol BaseTestCase {
  /// 초기에 주입받아야 할 데이터를 지정합니다
  func given(_ task: () -> Void)
  
  /// 발생해야 할 이벤트, 또는 메소드 호출등을 실행시킵니다
  func when(_ task: () -> Void)
  
  /// 결과 값이 기대와 같은지 확인합니다
  func then(_ task: () -> Void)
}

public extension BaseTestCase {
  
  func given(_ task: () -> Void) {
    task()
  }
  
  func when(_ task: () -> Void) {
    task()
  }
  
  func then(_ task: () -> Void) {
    task()
  }
}
