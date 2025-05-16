//
//  SideBar.swift
//  Mark-In
//
//  Created by 이정동 on 4/13/25.
//

import SwiftUI

import DesignSystem
import ReducerKit

struct SideBar: View {
  let store: StoreOf<MainReducer>
  
  var body: some View {
    VStack(alignment: .leading) {
      
      List(selection: .init(
        get: { store.state.selectedTab },
        set: { store.send(.changeTab($0)) })
      ) {
        Section("기본") {
          ForEach(
            store.state.defaultTabs,
            id: \.self
          ) { tab in
            NavigationLink(value: tab) {
              Label(tab.title, systemImage: tab.icon)
            }
          }
        }
        
        Section("저장된 폴더") {
          ForEach(
            store.state.folderTabs,
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
        .foregroundStyle(.markBlack20)
      
      Button(action: {
        store.send(.presentSheet(.addFolder))
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
  SideBar(store: .init(
    initialState: MainReducer.State(),
    reducer: MainReducer()
  ))
}
