//
//  AddLinkView.swift
//  Mark-In
//
//  Created by 이정동 on 4/23/25.
//

import SwiftUI

import DesignSystem

struct AddLinkView: View {
  @Environment(\.dismiss) var dismiss
  @State private var viewModel = AddLinkViewModel()
  @State private var title: String = ""
  @State private var url: String = ""
  
  @State private var currentFolder: Folder
  
  private let folders: [Folder]
  private let completion: (Link) -> Void
  
  private var isSaving: Bool {
    viewModel.state.isSaving
  }
  
  init(
    folders: [Folder],
    completion: @escaping (Link) -> Void
  ) {
    self.folders = folders
    self._currentFolder = State(initialValue: folders[0])
    self.completion = completion
  }
  
  var body: some View {
    VStack {
      Text("주소를 다음에 추가:")
        .frame(maxWidth: .infinity, alignment: .leading)
      
      VStack(spacing: 8) {
        Picker("", selection: $currentFolder) {
          ForEach(folders, id: \.self) { folder in
            Label(title: {
              Text(folder.name)
            }, icon: {
              Image(systemName: "folder")
            })
              .tag(folder)
          }
        }
        .pickerStyle(.menu)
        .labelsHidden()
        
        TextField("", text: $url, prompt: Text("주소"))
          .textFieldStyle(.roundedBorder)
        
        TextField("", text: $title, prompt: Text("제목(선택)"))
          .textFieldStyle(.roundedBorder)
      }
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
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay {
              RoundedRectangle(cornerRadius: 6)
                .stroke(.markBlack10, lineWidth: 0.5)
            }
        }
        .disabled(isSaving)

        Button {
          let link = WriteLink(
            url: url,
            title: title,
            folderID: currentFolder.id
          )
          viewModel.send(.addLinkButtonTapped(link: link))
        } label: {
          Text("추가")
            .padding(.vertical, 4)
            .padding(.horizontal, 14)
            .foregroundStyle(.markWhite)
            .background(.markPoint)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .disabled(url.isEmpty || isSaving)
      }
      .frame(maxWidth: .infinity, alignment: .trailing)
      .padding(.top, 18)
      .font(.pretendard(size: 14, weight: .medium))
      .buttonStyle(.plain)
    }
    .padding(20)
    .frame(width: 400)
    .onChange(of: viewModel.state.createdLink) {
      guard let link = $1 else { return }
      completion(link)
      dismiss()
    }
    .alert(
      "링크 생성에 실패했습니다.",
      isPresented: .init(
        get: { viewModel.state.isError },
        set: { viewModel.send(.occurError($0)) }
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
  AddLinkView(
    folders: [
      .init(id: "", name: "기본폴더", createdBy: .now),
      .init(id: "1", name: "폴더1", createdBy: .now),
    ]
  ) {
    print($0)
  }
}
