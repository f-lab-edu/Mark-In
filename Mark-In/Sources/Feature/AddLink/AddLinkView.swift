//
//  AddLinkView.swift
//  Mark-In
//
//  Created by 이정동 on 4/23/25.
//

import SwiftUI

import DesignSystem

// TODO: 후에 제거 예정
private struct TestFolder1: Hashable {
  var id: String
  var name: String
  
  static let dummy: [Self] = [
    .init(id: "1", name: "Root"),
    .init(id: "2", name: "Work"),
    .init(id: "3", name: "Personal"),
  ]
}

struct AddLinkView: View {
  @Environment(\.dismiss) var dismiss
  @State private var title: String = ""
  @State private var url: String = ""
  
  @State private var currentFolder: TestFolder1 = TestFolder1.dummy[0]
  
  var body: some View {
    VStack {
      Text("주소를 다음에 추가:")
        .frame(maxWidth: .infinity, alignment: .leading)
      
      VStack(spacing: 8) {
        Picker("", selection: $currentFolder) {
          ForEach(TestFolder1.dummy, id: \.self) { folder in
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
        
        TextField("", text: $title, prompt: Text("제목"))
          .textFieldStyle(.roundedBorder)
        
        TextField("", text: $url, prompt: Text("주소"))
          .textFieldStyle(.roundedBorder)
      }
      .padding(.top, 14)
      
      
      HStack {
        Button {
          dismiss()
        } label: {
          Text("취소")
            .padding(.vertical, 4)
            .padding(.horizontal, 14)
            .foregroundStyle(.black)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay {
              RoundedRectangle(cornerRadius: 6)
                .stroke(.gray, lineWidth: 0.5)
            }
        }

        Button {
          // TODO: 링크 추가 로직
          dismiss()
        } label: {
          Text("추가")
            .padding(.vertical, 4)
            .padding(.horizontal, 14)
            .foregroundStyle(.white)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
      }
      .frame(maxWidth: .infinity, alignment: .trailing)
      .padding(.top, 18)
      .font(.pretendard(size: 14, weight: .medium))
      .buttonStyle(.plain)
    }
    .padding(20)
    .frame(width: 400)
  }
}

#Preview {
  AddLinkView()
}
