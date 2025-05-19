//
//  DIContainer.swift
//  DIContainer
//
//  Created by 이정동 on 5/18/25.
//

import Foundation

public final class DIContainer {
  public static let shared = DIContainer()
  private var dependencies: [String: Any] = [:]
  
  private init() {}
  
  public func register<T>(_ dependency: T) {
    let key = String(describing: T.self)
    dependencies[key] = dependency
  }
  
  public func resolve<T>() -> T {
    let key = String(describing: T.self)
    let dependency = dependencies[key]
    
    guard let dependency = dependency as? T else {
      fatalError("\(key)는 register되지 않았어어요. resolve 부르기전에 register 해주세요")
    }
    
    return dependency
  }
}

@propertyWrapper
public struct Dependency<T> {
  public let wrappedValue: T
  
  public init() {
    self.wrappedValue = DIContainer.shared.resolve()
  }
}
