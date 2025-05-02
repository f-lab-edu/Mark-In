//
//  LoginView.swift
//  Mark-In
//
//  Created by 이정동 on 4/30/25.
//

import SwiftUI
import AuthenticationServices

import DesignSystem
import Util

struct LoginView: View {
  @State private var loginViewModel = LoginViewModel()
  
  var body: some View {
    ZStack {
      LinearGradient(
        colors: [.markPoint, .markWhite],
        startPoint: .top,
        endPoint: .bottom
      )
      .ignoresSafeArea()
      
      VStack(spacing: 28) {
        headerView
        
        BodyView(loginViewModel: loginViewModel)
      }
    }
  }
  
  @ViewBuilder
  private var headerView: some View {
    VStack(spacing: 0) {
      Text("Mark-in")
        .font(.pretendard(size: 50, weight: .black))
        .foregroundStyle(.markWhite)
      
      Text("하나로 관리하는 쉬운 북마크")
        .font(.pretendard(size: 18, weight: .semiBold))
        .foregroundStyle(.markWhite)
    }
  }
}

private struct BodyView: View {
  private let loginViewModel: LoginViewModel
  
  init(loginViewModel: LoginViewModel) {
    self.loginViewModel = loginViewModel
  }
  
  var body: some View {
    VStack(spacing: 2) {
      Group {
        titleView
        
        divider
        
        SignInButtonList(loginViewModel: loginViewModel)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .foregroundStyle(.black)
    .frame(width: 386, height: 210)
    .padding(22)
    .background(
      RoundedRectangle(cornerRadius: 15)
        .fill(.markWhite)
    )
  }
  
  private var titleView: some View {
    VStack(alignment: .leading, spacing: 7) {
      Text("로그인")
        .font(.pretendard(size: 20, weight: .semiBold))
        .foregroundStyle(.markBlack)
      
      Text("SNS로 간편하게 로그인하고 마크인을 시작해 보세요")
        .font(.pretendard(size: 12, weight: .medium))
        .foregroundStyle(.markBlack30)
    }
  }
  
  @ViewBuilder
  private var divider: some View {
    Spacer()
    Rectangle()
      .frame(height: 0.5)
      .foregroundStyle(.markBlack20)
    Spacer()
  }
}

private struct SignInButtonList: View {
  @Environment(\.authorizationController) private var authorizationController
  private let loginViewModel: LoginViewModel
  
  init(loginViewModel: LoginViewModel) {
    self.loginViewModel = loginViewModel
  }
  
  var body: some View {
    VStack(spacing: 12) {
      SignInButton(provider: .apple) {
        loginViewModel.send(.appleLoginButtonTapped(authorizationController))
      }
      
      SignInButton(provider: .google) {
        // TODO: 구글 로그인 로직
      }
    }
  }
}

private struct SignInButton: View {
  let provider: OAuthProvider
  
  let action: () -> Void
  
  private var image: Image {
    switch provider {
    case .apple: Image(.apple)
    case .google: Image(.google)
    @unknown default: Image(systemName: "questionmark")
    }
  }
  
  private var title: String {
    switch provider {
    case .apple: "Apple"
    case .google: "Google"
    @unknown default: "Unknown"
    }
  }
  
  var body: some View {
    Button {
      action()
    } label: {
      HStack(spacing: 4) {
        image
          .resizable()
          .frame(width: 22, height: 22)
        
        Text("\(title)로 시작하기")
          .font(.pretendard(size: 18, weight: .semiBold))
          .foregroundStyle(.markBlack)
      }
      .padding(.vertical, 15)
      .frame(maxWidth: .infinity)
      .contentShape(Rectangle())
    }
    .buttonStyle(.plain)
    .clipShape(
      RoundedRectangle(cornerRadius: 10)
    )
    .overlay(content: {
      RoundedRectangle(cornerRadius: 10)
        .stroke(lineWidth: 0.5)
        .fill(.markBlack30)
    })
  }
}

#Preview {
  LoginView()
    .frame(width: 600, height: 400)
}
