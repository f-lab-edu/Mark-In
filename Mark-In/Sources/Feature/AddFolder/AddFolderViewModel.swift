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
    var isLoading: Bool = false
    var isError: Bool = false
  }
  
  enum Action {
    case didTapAddLinkButton(title: String)
    case didCompleteSave(Folder)
    case updateErrorState(Bool)
  }
  
  private let generateFolderUseCase: GenerateFolderUseCase
  
  private(set) var state: State = .init()
  
  init() {
    // TODO: DIContainer PR 머지 이후 DIContainer를 통해 의존성 주입
    self.generateFolderUseCase = GenerateFolderUseCaseImpl(folderRepository: FolderRepositoryImpl())
  }
  
  func send(_ action: Action) {
    let effect = reduce(state: &state, action: action)
    handleEffect(effect)
  }
  
  func reduce(state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .didTapAddLinkButton(let title):
      state.isLoading = true
      
      return .run {
        do {
          let result = try await self.generateFolderUseCase.execute(name: title)
          return .didCompleteSave(result)
        } catch {
          return .updateErrorState(true)
        }
      }
      
    case .didCompleteSave(let folder):
      state.isLoading = false
      state.createdFolder = folder
      return .none
      
    case .updateErrorState(let bool):
      state.isLoading = false
      state.isError = bool
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

