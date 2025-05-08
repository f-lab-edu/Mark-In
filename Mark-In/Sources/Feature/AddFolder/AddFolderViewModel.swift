//
//  AddFolderViewModel.swift
//  Mark-In
//
//  Created by 이정동 on 5/8/25.
//

import Foundation

@Observable @MainActor
final class AddFolderViewModel: Reducer {
  struct State {
    var createdFolder: Folder?
    var isSaving: Bool = false
  }
  
  enum Action {
    case addLinkButtonTapped(title: String)
    case completeSave(Folder)
  }
  
  private(set) var state: State = .init()
  
  func send(_ action: Action) {
    let effect = reduce(state: &state, action: action)
    handleEffect(effect)
  }
  
  func reduce(state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .addLinkButtonTapped(let title):
      state.isSaving = true
      
      // TODO: 실제 저장 과정 구현 예정
      return .run {
        try? await Task.sleep(nanoseconds: 3_000_000_000)
        return .completeSave(.init(id: "", name: title, createdBy: .now))
      }
    case .completeSave(let folder):
      state.isSaving = false
      state.createdFolder = folder
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

