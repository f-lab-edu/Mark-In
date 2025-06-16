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
  let store: Store<MainReducer>
  
  @State private var isPresentedDialog: Bool = false
  @State private var deleteFolder: Folder?
  
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
            .contextMenu {
              if case .folder(let folder) = tab {
                Button {
                  isPresentedDialog = true
                  deleteFolder = folder
                } label: {
                  Text("삭제")
                }
                .disabled(folder.id == nil)
              }
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
    .confirmationDialog(
      "이 폴더를 삭제하시겠습니까?",
      isPresented: $isPresentedDialog
    ) {
      Button(role: .destructive) {
        store.send(.deleteFolderButtonTapped(
          folder: deleteFolder!,
          includingChildren: false
        ))
      } label: {
        Text("폴더만 삭제")
      }
      
      Button(role: .destructive) {
        store.send(.deleteFolderButtonTapped(
          folder: deleteFolder!,
          includingChildren: true
        ))
      } label: {
        Text("폴더와 링크 삭제")
      }

      Button(role: .cancel) {
        deleteFolder = nil
      } label: {
        Text("취소")
      }
    } message: {
      Text("이 폴더를 삭제하면 하위 링크도 함께 삭제하거나, 그대로 유지할 수 있습니다.")
    }
  }
}

#Preview {
  SideBar(store: .init(
    initialState: MainReducer.State(),
    reducer: MainReducer()
  ))
}
