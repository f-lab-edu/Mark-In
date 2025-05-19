//
//  AddFolderViewModel.swift
//  Mark-In
//
//  Created by 이정동 on 5/8/25.
//

import Foundation

import ReducerKit

struct AddFolderReducer: Reducer {
  struct State {
    var createdFolder: Folder?
    var isLoading: Bool = false
    var isError: Bool = false
  }
  
  enum Action {
    case didTapAddFolderButton(name: String)
    case didCompleteSave(Folder)
    case updateErrorState(Bool)
  }
  
  private let generateFolderUseCase: GenerateFolderUseCase
  
  init() {
    self.generateFolderUseCase = DIContainer.shared.resolve()
  }
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .didTapAddFolderButton(let name):
      state.isLoading = true
      
      return .run {
        do {
          let writeFolder = WriteFolder(name: name)
          let result = try await self.generateFolderUseCase.execute(writeFolder: writeFolder)
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
}

