//
//  AddFolderView.swift
//  Mark-In
//
//  Created by 이정동 on 5/8/25.
//

import SwiftUI

import DesignSystem
import ReducerKit

struct AddFolderView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var store: Store<AddFolderReducer> = .init(
    initialState: AddFolderReducer.State(),
    reducer: AddFolderReducer()
  )
  @State private var name: String = ""
  
  private var isSaving: Bool {
    store.state.isLoading
  }
  
  let completion: (Folder) -> ()
  
  var body: some View {
    VStack(spacing: 0) {
      Text("폴더를 추가:")
        .frame(maxWidth: .infinity, alignment: .leading)
      
      MarkTextField(text: $title, placeholder: "제목")
        .padding(.top, 14)
        .disabled(isSaving)
      
      HStack {
        if isSaving {
          ProgressView()
            .frame(width: 12, height: 12)
            .scaleEffect(0.4, anchor: .center)
        }
        
        MarkCancelButton {
          dismiss()
        }
        .disabled(isSaving)
        
        MarkAddButton {
          let writeFolder = WriteFolder(name: name)
          store.send(.didTapAddFolderButton(writeFolder))
        }
        .disabled(name.isEmpty || isSaving)
      }
      .frame(maxWidth: .infinity, alignment: .trailing)
      .padding(.top, 18)
    }
    .padding(20)
    .frame(width: 400)
    .onChange(of: store.state.createdFolder) {
      guard let folder = $1 else { return }
      completion(folder)
      dismiss()
    }
    .alert(
      "폴더 생성에 실패했습니다.",
      isPresented: .init(
        get: { store.state.isError },
        set: { store.send(.updateErrorState($0)) }
      )
    ) {
      Button(role: .cancel) {
      } label: {
        Text("확인")
      }
    }
  }
}

#Preview {
  AddFolderView() {
    print($0)
  }
}
