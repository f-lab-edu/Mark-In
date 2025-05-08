//
//  AddFolderView.swift
//  Mark-In
//
//  Created by 이정동 on 5/8/25.
//

import SwiftUI

import DesignSystem

struct AddFolderView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var title: String = ""
  
  var body: some View {
    VStack(spacing: 0) {
      Text("폴더를 추가:")
        .frame(maxWidth: .infinity, alignment: .leading)
      
      TextField("", text: $title, prompt: Text("제목"))
        .textFieldStyle(.roundedBorder)
        .padding(.top, 14)
      
      HStack {
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
        
        Button {
          // TODO: 폴더 추가 로직
          dismiss()
        } label: {
          Text("추가")
            .padding(.vertical, 4)
            .padding(.horizontal, 14)
            .foregroundStyle(.markWhite)
            .background(.markPoint)
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
  AddFolderView()
}
