//
//  ContentView.swift
//  Mark-In
//
//  Created by 이정동 on 3/22/25.
//

import SwiftUI
import DesignSystem


struct MainView: View {
  @State private var selectedIndex: Int? = 1
  @State private var searchText: String = ""
  
  var body: some View {
    VStack {
      NavigationSplitView {
        SideBar(selectedIndex: $selectedIndex)
          .navigationSplitViewColumnWidth(
            min: 200, ideal: 200, max: 300
          )
      } detail: {
        LinkListView()
      }
      .navigationTitle("")
    }
    .searchable(text: $searchText, placement: .toolbar)
    .toolbar {
      ToolbarItemGroup(placement: .primaryAction) {
        toolBarButtons
      }
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
        // TODO: 구현 예정
      } label: {
        Image(systemName: "person.circle.fill")
          .resizable()
          .frame(width: 22, height: 22)
      }
    }
  }
}

#Preview {
  MainView()
    .frame(width: 900)
}
