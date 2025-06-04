//
//  DIContainer.swift
//  Mark-In
//
//  Created by 이정동 on 5/5/25.
//

import Foundation

import AppDI
import LinkMetadataKit
import LinkMetadataKitInterface


extension DIContainer {
  func registerDependencies() {
    /// Core-Level 의존성 등록
    registerCoreDependencies()
    
    /// Domain-Level 의존성 등록
    registerRepositoryDependencies()
    registerUseCaseDependencies()
  }
}

private extension DIContainer {
  // MARK: - Core
  func registerCoreDependencies() {
    let keychainStore: KeychainStore = KeychainStoreImpl()
    let linkMetadataProvider: LinkMetadataProvider = LinkMetadataProviderImpl()
    let authUserManager: AuthUserManager = AuthUserManagerImpl(
      keychainStore: keychainStore
    )
    
    register(keychainStore)
    register(linkMetadataProvider)
    register(authUserManager)
  }
  
  // MARK: - Domain - Repository
  func registerRepositoryDependencies() {
    let folderRepository: FolderRepository = FolderRepositoryImpl()
    let linkRepository: LinkRepository = LinkRepositoryImpl(
      linkMetadataProvider: resolve()
    )
    
    register(folderRepository)
    register(linkRepository)
  }
  
  // MARK: - Domain - UseCase
  func registerUseCaseDependencies() {
    let fetchLinkListUseCase: FetchLinkListUseCase = FetchLinkListUseCaseImpl(
      authUserManager: resolve(),
      linkRepository: resolve()
    )
    let fetchFolderListUseCase: FetchFolderListUseCase = FetchFolderListUseCaseImpl(
      authUserManager: resolve(),
      folderRepository: resolve()
    )
    let generateLinkUseCase: GenerateLinkUseCase = GenerateLinkUseCaseImpl(
      authUserManager: resolve(),
      linkRepository: resolve()
    )
    let generateFolderUseCase: GenerateFolderUseCase = GenerateFolderUseCaseImpl(
      authUserManager: resolve(),
      folderRepository: resolve()
    )
    let signInUseCase: SignInUseCase = SignInUseCaseImpl(
      keychainStore: resolve(),
      authUserManager: resolve()
    )
    let signOutUseCase: SignOutUseCase = SignOutUseCaseImpl(
      authUserManager: resolve()
    )
    let withdrawalUseCase: WithdrawalUseCase = WithdrawalUseCaseImpl(
      keychainStore: resolve(),
      authUserManager: resolve(),
      linkRepository: resolve(),
      folderRepsoitory: resolve()
    )
    let deleteLinkUseCase: DeleteLinkUseCase = DeleteLinkUseCaseImpl(
      authUserManager: resolve(),
      linkRepository: resolve()
    )
    let deleteFolderUseCase: DeleteFolderUseCase = DeleteFolderUseCaseImpl(
      authUserManager: resolve(),
      linkRepository: resolve(),
      folderRepository: resolve()
    )
    
    register(fetchLinkListUseCase)
    register(fetchFolderListUseCase)
    register(generateLinkUseCase)
    register(generateFolderUseCase)
    register(signInUseCase)
    register(signOutUseCase)
    register(withdrawalUseCase)
    register(deleteLinkUseCase)
    register(deleteFolderUseCase)
  }
}
