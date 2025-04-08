//
//  Mark_InApp.swift
//  Mark-In
//
//  Created by 이정동 on 4/8/25.
//

import SwiftUI
import DesignSystem

@main
struct Mark_InApp: App {
  
  init() {
    FontLoader.registerFont()
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
