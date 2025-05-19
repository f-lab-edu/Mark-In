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

extension DIContainer {
  func registerDependencies() {
    
    /// Core
    let keychainStore: KeychainStore = KeychainStoreImpl()
    let linkMetadataProvider: LinkMetadataProvider = LinkMetadataProviderImpl()
    let authUserManager: AuthUserManager = AuthUserManagerImpl(
      keychainStore: keychainStore
    )
    
    register(linkMetadataProvider)
    register(authUserManager)
    
    /// Repository
    let folderRepository: FolderRepository = FolderRepositoryImpl()
    let linkRepository: LinkRepository = LinkRepositoryImpl(
      linkMetadataProvider: linkMetadataProvider
    )
    
    register(folderRepository)
    register(linkRepository)
    
    /// UseCase
    let fetchLinkListUseCase: FetchLinkListUseCase = FetchLinkListUseCaseImpl(
      linkRepository: linkRepository
    )
    let fetchFolderListUseCase: FetchFolderListUseCase = FetchFolderListUseCaseImpl(
      folderRepository: folderRepository
    )
    let generateLinkUseCase: GenerateLinkUseCase = GenerateLinkUseCaseImpl(
      linkRepository: linkRepository
    )
    let generateFolderUseCase: GenerateFolderUseCase = GenerateFolderUseCaseImpl(
      folderRepository: folderRepository
    )
    let signInUseCase: SignInUseCase = SignInUseCaseImpl(
      keychainStore: keychainStore,
      authUserManager: authUserManager
    )
    let signOutUseCase: SignOutUseCase = SignOutUseCaseImpl(
      authUserManager: authUserManager
    )
    let withdrawalUseCase: WithdrawalUseCase = WithdrawalUseCaseImpl(
      keychainStore: keychainStore,
      authUserManager: authUserManager
    )
    
    register(fetchLinkListUseCase)
    register(fetchFolderListUseCase)
    register(generateLinkUseCase)
    register(generateFolderUseCase)
    register(signInUseCase)
    register(signOutUseCase)
    register(withdrawalUseCase)
  }
}
