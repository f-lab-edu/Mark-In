//
//  MainViewModel.swift
//  Mark-In
//
//  Created by 이정동 on 4/25/25.
//

import Foundation

@Observable
final class MainViewModel: Reducer {
  struct State {
    var isLoading: Bool = true
    
    var tabs: [SidebarTab] = [.total, .pin, .nonRead]
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
      (1...3).forEach { state.tabs.append(.folder(.init(id: "\($0)", name: "\($0)"))) }
      state.isLoading = false
      return .none
      
    case .changeTab(let tab):
      state.selectedTab = tab
      return .none
    }
  }
  
  private func handleEffect(_ effect: Effect<Action>) {
    switch effect {
    case .none: break
    case .run(let action):
      Task { send(await action()) }
    }
  }
}

enum SidebarTab: Hashable {
  case total
  case pin
  case nonRead
  case folder(TestFolder)
  
  var title: String {
    switch self {
    case .total: "전체"
    case .pin: "즐겨찾기"
    case .nonRead: "읽지 않음"
    case .folder(let folder): folder.name
    }
  }
  
  var icon: String {
    switch self {
    case .total: "clock"
    case .pin: "star"
    case .nonRead: "xmark.circle"
    case .folder(_): "folder"
    }
  }
  
  var isFolder: Bool {
    if case .folder(_) = self { true }
    else { false }
  }
}

// TODO: 이후 제거 예정
struct TestFolder: Hashable {
  var id: String
  var name: String
}
