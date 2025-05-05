//
//  DIContainer.swift
//  Mark-In
//
//  Created by 이정동 on 5/5/25.
//

import Foundation

// TODO: 코어 모듈로 이전
final class DIContainer {
  static let shared = DIContainer()
  private var dependencies: [String: Any] = [:]
  
  private init() {}
  
  func register<T>(_ dependency: T) {
    let key = String(describing: T.self)
    dependencies[key] = dependency
  }
  
  func resolve<T>() -> T {
    let key = String(describing: T.self)
    let dependency = dependencies[key]
    
    guard let dependency = dependency as? T else {
      fatalError("\(key)는 register되지 않았어어요. resolve 부르기전에 register 해주세요")
    }
    
    return dependency
  }
}

// TODO: Core 모듈 or Feature(공통) 모듈 중 어느 곳이 적합한지 고민
@Observable
final class AppState {
  var isLoginned: Bool = false
}

extension DIContainer {
  func registerDependencies() {
    /// AppState
    let appState = AppState()
    
    register(appState)
    
    /// Repository
    let authRepository = AuthRepositoryImpl()
    let folderRepository = FolderRepositoryImpl()
    let linkRepository = LinkRepositoryImpl()
    
    register(authRepository as AuthRepository)
    register(folderRepository as FolderRepository)
    register(linkRepository as LinkRepository)
    
    /// UseCase
    let fetchCurrentUserIDUseCase = FetchCurrentUserIDUseCaseImpl(authRepository: authRepository)
    
    register(fetchCurrentUserIDUseCase as FetchCurrentUserIDUseCase)
  }
}
