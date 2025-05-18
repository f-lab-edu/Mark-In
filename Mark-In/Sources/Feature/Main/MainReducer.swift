//
//  MainViewModel.swift
//  Mark-In
//
//  Created by 이정동 on 4/25/25.
//

import Foundation

import AppDI
import ReducerKit

struct MainReducer: Reducer {
  struct State {
    var isLoading: Bool = true
    
    var links: [WebLink] = []
    
    var defaultTabs: [SidebarTab] = [.total, .pin, .nonRead]
    var folderTabs: [SidebarTab] = []
    var selectedTab: SidebarTab? = .total
    
    var isPresentedSheet: SheetType?
  }
  
  enum Action {
    case onAppear
    case fetchSucceeded([WebLink], [Folder])
    case changeTab(SidebarTab?)
    
    case presentSheet(SheetType?)
    
    case didCreateLink(WebLink)
    case didCreateFolder(Folder)
    
    case occuredError
    
    case empty
  }
  
  @Dependency private var fetchLinkListUseCase: FetchLinkListUseCase
  @Dependency private var fetchFolderListUseCase: FetchFolderListUseCase
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
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
      
      state.folderTabs.append(.folder(.init(id: nil, name: "기본폴더", createdBy: .now)))
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
      
    case .didCreateLink(let link):
      state.links.insert(link, at: 0)
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
}

extension MainReducer {
  enum SheetType: Identifiable {
    case addLink
    case addFolder
    
    var id: String { String(describing: self) }
  }
}
