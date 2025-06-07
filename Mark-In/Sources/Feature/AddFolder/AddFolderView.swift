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
  @State private var title: String = ""
  
  private var isSaving: Bool {
    store.state.isLoading
  }
  
  let completion: (Folder) -> ()
  
  var body: some View {
    VStack(spacing: 0) {
      Text("폴더를 추가:")
        .frame(maxWidth: .infinity, alignment: .leading)
      
      TextField("", text: $title, prompt: Text("제목"))
        .textFieldStyle(.roundedBorder)
        .padding(.top, 14)
        .disabled(isSaving)
      
      HStack {
        if isSaving {
          ProgressView()
            .frame(width: 12, height: 12)
            .scaleEffect(0.4, anchor: .center)
        }
        
        Button {
          dismiss()
        } label: {
          Text("취소")
            .padding(.vertical, 4)
            .padding(.horizontal, 14)
            .foregroundStyle(.markBlack)
            .background(.markWhite)
            .markRoundedOutline(
              cornerRadius: 6,
              lineWidth: 0.5,
              lineColor: .markBlack10
            )
        }
        .disabled(title.isEmpty || isSaving)
        
        Button {
          store.send(.didTapAddFolderButton(name: title))
        } label: {
          Text("추가")
            .padding(.vertical, 4)
            .padding(.horizontal, 14)
            .foregroundStyle(.markWhite)
            .background(.markPoint)
            .markRoundedOutline(cornerRadius: 6)
        }
        .disabled(title.isEmpty || isSaving)
      }
      .frame(maxWidth: .infinity, alignment: .trailing)
      .padding(.top, 18)
      .font(.pretendard(size: 14, weight: .medium))
      .buttonStyle(.plain)
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
