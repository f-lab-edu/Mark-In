//
//  AddLinkViewModel.swift
//  Mark-In
//
//  Created by 이정동 on 5/11/25.
//

import Foundation

// TODO: DIContainer 적용 시 제거
import LinkMetadataKit
import LinkMetadataKitInterface

@Observable @MainActor
final class AddLinkViewModel: Reducer {
  struct State {
    var createdLink: Link?
    var isSaving: Bool = false
    var isError: Bool = false
  }
  
  enum Action {
    case addLinkButtonTapped(WriteLink)
    case completeSave(Link)
    case occurError(Bool)
  }
  
  private let generateLinkUseCase: GenerateLinkUseCase
  
  private(set) var state: State = .init()
  
  init() {
    // TODO: DIContainer 의존성 주입
    self.generateLinkUseCase = GenerateLinkUseCaseImpl(linkRepository: LinkRepositoryImpl(linkMetadataProvider: LinkMetadataProviderImpl()))
  }
  
  func send(_ action: Action) {
    let effect = reduce(state: &state, action: action)
    handleEffect(effect)
  }
  
  func reduce(state: inout State, action: Action) -> Effect<Action> {
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
