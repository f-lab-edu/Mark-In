//
//  MyPageView.swift
//  Mark-In
//
//  Created by 이정동 on 5/13/25.
//

import SwiftUI

import DesignSystem

private enum ViewConstants {
  static let minContentWidth: CGFloat = 164
}

struct MyPageView: View {
  @State private var contentWidth = ViewConstants.minContentWidth

  var body: some View {
    VStack(spacing: 30) {
      headerTitle
        .padding(.top, 16)
      
      footerButtons
        .padding(.bottom, 12)
    }
    .frame(width: contentWidth)
  }

  private var headerTitle: some View {
    VStack(spacing: 2) {
      Text("User Name")
        .font(.pretendard(size: 14, weight: .semiBold))
        .foregroundStyle(.markBlack)

      Text("asdfasdfasdf012345@gmail.com")
        .font(.pretendard(size: 10, weight: .regular))
        .tint(.markBlack)
        .fixedSize()
        .padding(.horizontal, 8)
        .background(
          GeometryReader { geo in
            Color.clear
              .onAppear {
                let width = geo.size.width
                contentWidth = max(width, ViewConstants.minContentWidth)
              }
          }
        )
    }
  }

  private var footerButtons: some View {
    VStack(spacing: 8) {
      Button {
        // TODO: 로그아웃
      } label: {
        Text("로그아웃")
          .font(.pretendard(size: 12, weight: .regular))
          .foregroundStyle(.markBlack)
      }

      Divider()
        .padding(.horizontal, 8)

      Button {
        // TODO: 회원탈퇴
      } label: {
        Text("회원 탈퇴")
          .font(.pretendard(size: 12, weight: .regular))
          .foregroundStyle(.markRed)
      }
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  MyPageView()
}
