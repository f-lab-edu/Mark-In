//
//  Mark_InApp.swift
//  Mark-In
//
//  Created by 이정동 on 4/8/25.
//

import SwiftUI
import DesignSystem

import FirebaseCore

@main
struct Mark_InApp: App {
  
  init() {
    FontLoader.registerFont()
    
    Self.configureFirebase()
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}

extension Mark_InApp {
  static func configureFirebase() {
#if DEBUG
    let resource = "GoogleService-Info-Dev"
#else
    let resource = "GoogleService-Info"
#endif
    
    guard let filePath = Bundle.main.path(forResource: resource, ofType: "plist"),
          let options = FirebaseOptions(contentsOfFile: filePath)
    else {
      print("Firebase: \(resource) not found or invalid.")
      return
    }
    
    FirebaseApp.configure(options: options)
  }
}
