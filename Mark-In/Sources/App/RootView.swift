//
//  RootView.swift
//  Mark-In
//
//  Created by 이정동 on 5/5/25.
//

import SwiftUI

import DesignSystem

struct RootView: View {
  
  @State private var rootViewModel = RootViewModel()
  
  var body: some View {
    ZStack {
      if rootViewModel.state.isSplashVisible {
        SplashView()
      } else {
        if rootViewModel.state.currentUser != nil {
          MainView()
        } else {
          LoginView()
        }
      }
    }
    .onAppear {
      rootViewModel.send(.onAppear)
    }
  }
}


private struct SplashView: View {
  
  var body: some View {
    ZStack {
      LinearGradient(
        colors: [.markPoint, .markWhite],
        startPoint: .top,
        endPoint: .bottom
      )
      .ignoresSafeArea()
      
      Text("Splash View")
    }
  }
}

#Preview {
  RootView()
}
