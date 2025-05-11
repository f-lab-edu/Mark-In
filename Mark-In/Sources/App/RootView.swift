//
//  RootView.swift
//  Mark-In
//
//  Created by 이정동 on 5/5/25.
//

import SwiftUI

import DesignSystem

struct RootView: View {
  
  @State private var authManager: AuthManager = DIContainer.shared.resolve()
  
  var body: some View {
    ZStack {
      if authManager.user != nil {
        MainView()
      } else {
        LoginView()
      }
    }
  }
}

#Preview {
  RootView()
}
