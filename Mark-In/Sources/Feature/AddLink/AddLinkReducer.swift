//
//  AddLinkViewModel.swift
//  Mark-In
//
//  Created by 이정동 on 5/11/25.
//

import Foundation

import AppDI
import ReducerKit

struct AddLinkReducer: Reducer {
  struct State {
    var createdLink: Link?
    var isSaving: Bool = false
    var isError: Bool = false
  }
  
  enum Action {
    case addLinkButtonTapped(link: WriteLink)
    case completeSave(Link)
    case occurError(Bool)
  }
  
  @Dependency private var generateLinkUseCase: GenerateLinkUseCase
  
  func reduce(into state: inout State, action: Action) -> Effect<Action> {
    switch action {
    case .addLinkButtonTapped(let writeLink):
      state.isSaving = true
      return .run {
        do {
          let newLink = try await self.generateLinkUseCase.execute(writeLink: writeLink)
          return .completeSave(newLink)
        } catch {
          return .occurError(true)
        }
      }
    case .completeSave(let link):
      state.createdLink = link
      state.isSaving = false
      return .none
    case .occurError(let bool):
      state.isError = bool
      state.isSaving = false
      return .none
    }
  }
}
