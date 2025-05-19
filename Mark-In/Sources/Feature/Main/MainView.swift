//
//  ContentView.swift
//  Mark-In
//
//  Created by 이정동 on 3/22/25.
//

import SwiftUI

import DesignSystem

struct MainView: View {
  @State private var viewModel = MainViewModel()
  @State private var searchText: String = ""

  @State private var isPresentedMyPage: Bool = false
  
  var body: some View {
    ZStack {
      NavigationSplitView {
        SideBar(viewModel: viewModel)
          .navigationSplitViewColumnWidth(
            min: 200, ideal: 200, max: 300
          )
      } detail: {
        LinkListView(viewModel: viewModel)
      }
      .navigationTitle("")
      .searchable(text: $searchText, placement: .toolbar)
      .toolbar {
        ToolbarItemGroup(placement: .primaryAction) {
          toolBarButtons
        }
      }
      .disabled(viewModel.state.isLoading)
      
      if viewModel.state.isLoading {
        ProgressView()
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .contentShape(Rectangle())
          .background(.gray.opacity(0.5))
      }
    }
    .onAppear {
      viewModel.send(.onAppear)
    }
    .sheet(item: .init(
      get: { viewModel.state.isPresentedSheet },
      set: { viewModel.send(.presentSheet($0))
      }
    )) { type in
      buildSheet(type)
    }
  }
  
  private var toolBarButtons: some View {
    Group {
      Button {
        // TODO: 구현 예정
      } label: {
        Image(systemName: "rectangle.grid.2x2")
      }
      
      Button {
        // TODO: 구현 예정
      } label: {
        Image(systemName: "rectangle.grid.1x2")
      }
    
      Spacer()
      
      Button {
        // TODO: 구현 예정
      } label: {
        HStack(spacing: 0) {
          Image(systemName: "arrow.up.arrow.down")
          Image(systemName: "chevron.down")
            .resizable()
            .frame(width: 7, height: 5)
            .fontWeight(.bold)
        }
      }

      Spacer()
      Button {
        viewModel.send(.presentSheet(.addLink))
      } label: {
        Image(systemName: "plus")
      }
      Button {
        // TODO: 구현 예정
      } label: {
        Image(systemName: "checkmark")
      }
      
      Spacer()
      Button {
        isPresentedMyPage = true
      } label: {
        Image(systemName: "person.circle.fill")
          .resizable()
          .frame(width: 22, height: 22)
      }
      .popover(
        isPresented: $isPresentedMyPage,
        arrowEdge: .bottom
      ) {
        MyPageView()
      }
    }
  }
  
  @ViewBuilder
  private func buildSheet(_ type: MainViewModel.SheetType) -> some View {
    switch type {
    case .addLink:
      let folderTabs = viewModel.state.folderTabs
      let folders = folderTabs
        .compactMap {
          if case let .folder(folder) = $0 { folder }
          else { nil }
        }
      AddLinkView(folders: folders) {
        viewModel.send(.didCreateLink($0))
      }
    case .addFolder:
      AddFolderView() {
        viewModel.send(.didCreateFolder($0))
      }
    }
  }
}

#Preview {
  MainView()
    .frame(width: 900)
}
