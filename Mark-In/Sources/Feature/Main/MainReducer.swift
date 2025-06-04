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
    
    case deleteLinkButtonTapped(link: WebLink)
    case deleteFolderButtonTapped(folder: Folder, includingChildren: Bool)
    
    case occuredError
    
    case empty
  }
  
  @Dependency private var fetchLinkListUseCase: FetchLinkListUseCase
  @Dependency private var fetchFolderListUseCase: FetchFolderListUseCase
  @Dependency private var deleteLinkUseCase: DeleteLinkUseCase
  @Dependency private var deleteFolderUseCase: DeleteFolderUseCase
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .run {
        do {
          async let links = await self.fetchLinkListUseCase.execute()
          async let folders = await self.fetchFolderListUseCase.execute()
          
          return try await .fetchSucceeded(links, folders)
        } catch {
          return .occuredError
        }
      }
      
    case let .fetchSucceeded(links, folders):
      
      state.links = links
      
      state.folderTabs = [.folder(.init(id: nil, name: "기본폴더", createdAt: .now))]
      folders.forEach {
        state.folderTabs.append(
          .folder(.init(id: $0.id, name: $0.name, createdAt: $0.createdAt))
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
      
    case .deleteLinkButtonTapped(let link):
      state.isLoading = true
      return .run {
        do {
          try await self.deleteLinkUseCase.execute(linkID: link.id)
          return .onAppear
        } catch {
          return .occuredError
        }
      }
      
    case let .deleteFolderButtonTapped(folder, includingChildren):
      state.isLoading = true
      return .run {
        do {
          try await self.deleteFolderUseCase.execute(folderID: folder.id, includingChildren: includingChildren)
          return .onAppear
        } catch {
          return .occuredError
        }
      }
      
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
