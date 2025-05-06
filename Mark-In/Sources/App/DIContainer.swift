//
//  DIContainer.swift
//  Mark-In
//
//  Created by 이정동 on 5/5/25.
//

import Foundation

import LinkMetadataKit
import LinkMetadataKitInterface

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
    
    /// Core
    let linkMetadataProvider: LinkMetadataProvider = LinkMetadataProviderImpl()
    
    register(linkMetadataProvider)
    
    /// Repository
    let authRepository: AuthRepository = AuthRepositoryImpl()
    let folderRepository: FolderRepository = FolderRepositoryImpl()
    let linkRepository: LinkRepository = LinkRepositoryImpl(
      linkMetadataProvider: linkMetadataProvider
    )
    
    register(authRepository)
    register(folderRepository)
    register(linkRepository)
    
    /// UseCase
    let fetchCurrentUserIDUseCase: FetchCurrentUserIDUseCase = FetchCurrentUserIDUseCaseImpl(
      authRepository: authRepository
    )
    
    register(fetchCurrentUserIDUseCase)
  }
}
