//
//  MainViewModel.swift
//  Mark-In
//
//  Created by 이정동 on 4/25/25.
//

import Foundation

@MainActor @Observable
final class MainViewModel: Reducer {
  struct State {
    var isLoading: Bool = true
    
    var defaultTabs: [SidebarTab] = [.total, .pin, .nonRead]
    var folderTabs: [SidebarTab] = []
    var selectedTab: SidebarTab? = .total
  }
  
  enum Action {
    case onAppear
    case refresh
    case changeTab(SidebarTab?)
  }
  
  private(set) var state: State = .init()
  
  func send(_ action: Action) {
    let effect = reduce(state: &state, action: action)
    handleEffect(effect)
  }
  
  func reduce(state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .onAppear:
      return .run {
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        return .refresh
      }
      
    case .refresh:
      // TODO: 실제 데이터 가져오는 작업 구현 필요
      (1...3).forEach {
        state.folderTabs.append(.folder(.init(id: "\($0)", name: "\($0)", createdBy: .now)))
      }
      state.isLoading = false
      return .none
      
    case .changeTab(let tab):
      state.selectedTab = tab
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


