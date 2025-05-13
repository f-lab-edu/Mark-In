//
//  RootView.swift
//  Mark-In
//
//  Created by 이정동 on 5/5/25.
//

import SwiftUI

import DesignSystem

struct RootView: View {
  
  @State private var authUserManager: AuthUserManager = DIContainer.shared.resolve()
  
  var body: some View {
    ZStack {
      if authUserManager.user != nil {
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
