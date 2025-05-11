//
//  MainViewModel.swift
//  Mark-In
//
//  Created by 이정동 on 4/25/25.
//

import Foundation

// TODO: DIContainer 도입 시 제거
import LinkMetadataKit
import LinkMetadataKitInterface

@MainActor @Observable
final class MainViewModel: Reducer {
  struct State {
    var isLoading: Bool = true
    
    var links: [Link] = []
    
    var defaultTabs: [SidebarTab] = [.total, .pin, .nonRead]
    var folderTabs: [SidebarTab] = []
    var selectedTab: SidebarTab? = .total
    
    var isPresentedSheet: SheetType?
  }
  
  enum Action {
    case onAppear
    case fetchSucceeded([Link], [Folder])
    case changeTab(SidebarTab?)
    
    case presentSheet(SheetType?)
    
    case didCreateFolder(Folder)
    
    case occuredError
    
    case empty
  }
  
  private let fetchLinkListUseCase: FetchLinkListUseCase
  private let fetchFolderListUseCase: FetchFolderListUseCase
  
  private(set) var state: State = .init()
  
  init() {
    // TODO: DIContainer로 주입
    self.fetchLinkListUseCase = FetchLinkListUseCaseImpl(linkRepository: LinkRepositoryImpl(linkMetadataProvider: LinkMetadataProviderImpl()))
    self.fetchFolderListUseCase = FetchFolderListUseCaseImpl(folderRepository: FolderRepositoryImpl())
  }
  
  func send(_ action: Action) {
    let effect = reduce(state: &state, action: action)
    handleEffect(effect)
  }
  
  func reduce(state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .run {
        do {
          // TODO: 실제 로그인 유저 ID 전달
          async let links = await self.fetchLinkListUseCase.execute(userID: "testUser")
          async let folders = await self.fetchFolderListUseCase.execute(userID: "testUser")
          
          return try await .fetchSucceeded(links, folders)
        } catch {
          return .occuredError
        }
      }
      
    case let .fetchSucceeded(links, folders):
      
      state.links = links
      
      state.folderTabs.append(.folder(.init(id: "", name: "기본폴더", createdBy: .now)))
      folders.forEach {
        state.folderTabs.append(
          .folder(.init(id: $0.id, name: $0.name, createdBy: $0.createdBy))
        )
      }
      
      state.isLoading = false
      return .none
      
    case .changeTab(let tab):
      state.selectedTab = tab
      return .none
      
    case .presentSheet(let sheetType):
      state.isPresentedSheet = sheetType
      return .none
      
    case .didCreateFolder(let folder):
      state.folderTabs.append(.folder(folder))
      return .none
      
      // TODO: 에러 처리 로직 추가
    case .occuredError:
      return .none
      
    case .empty:
      return .none
    }
  }
  
  private func handleEffect(_ effect: Effect<Action>) {
    switch effect {
    case .none:
      break
    case .run(let action):
      Task.detached { [weak self] in
        let newAction = await action()
        await self?.send(newAction)
      }
    }
  }
}

extension MainViewModel {
  enum SheetType: Identifiable {
    case addLink
    case addFolder
    
    var id: String { String(describing: self) }
  }
}
