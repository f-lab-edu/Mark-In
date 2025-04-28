//
//  SideBar.swift
//  Mark-In
//
//  Created by 이정동 on 4/13/25.
//

import SwiftUI

import DesignSystem

struct SideBar: View {
  let viewModel: MainViewModel
  
  var body: some View {
    VStack(alignment: .leading) {
      
      List(selection: .init(
        get: { viewModel.state.selectedTab },
        set: { viewModel.send(.changeTab($0)) })
      ) {
        Section("기본") {
          ForEach(
            viewModel.state.tabs.filter { !$0.isFolder },
            id: \.self
          ) { tab in
            NavigationLink(value: tab) {
              Label(tab.title, systemImage: tab.icon)
            }
          }
        }
        
        Section("저장된 폴더") {
          ForEach(
            viewModel.state.tabs.filter { $0.isFolder },
            id: \.self
          ) { tab in
            NavigationLink(value: tab) {
              Label(tab.title, systemImage: tab.icon)
            }
          }
        }
      }
      .scrollContentBackground(.hidden)
      
      Spacer()
      
      Divider()
        .padding(.horizontal, 10)
        .foregroundStyle(.blue)
      
      Button(action: {
        // TODO: 구현 예정
      }, label: {
        Label("새로운 폴더 만들기", systemImage: "plus")
          .lineLimit(1)
          .padding(5)
      })
      .padding([.bottom, .leading], 10)
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  SideBar(viewModel: MainViewModel())
}
