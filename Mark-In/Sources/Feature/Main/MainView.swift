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
  @State private var isAddMode: Bool = false
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
    .sheet(isPresented: $isAddMode) {
      AddLinkView()
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
        // TODO: 구현 예정
        isAddMode = true
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
}

#Preview {
  MainView()
    .frame(width: 900)
}
