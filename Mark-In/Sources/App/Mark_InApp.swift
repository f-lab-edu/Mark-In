//
//  Mark_InApp.swift
//  Mark-In
//
//  Created by 이정동 on 4/8/25.
//

import SwiftUI

import FirebaseCore
import GoogleSignIn

import AppDI
import DesignSystem

@main
struct Mark_InApp: App {
  
  init() {
    FontLoader.registerFont()
    
    configureFirebase()
    configureGoogleSignIn()
    
    DIContainer.shared.registerDependencies()
  }
  
  var body: some Scene {
    WindowGroup {
      RootView()
        .frame(minWidth: 500, minHeight: 500)
        .onOpenURL { url in
          GIDSignIn.sharedInstance.handle(url)
        }
    }
  }
}

extension Mark_InApp {
  private func configureFirebase() {
#if DEBUG
    let resource = "GoogleService-Info-Dev"
#else
    let resource = "GoogleService-Info"
#endif
    
    guard let filePath = Bundle.main.path(forResource: resource, ofType: "plist"),
          let options = FirebaseOptions(contentsOfFile: filePath) else {
      fatalError("Firebase: \(resource) not found or invalid.")
    }
    
    FirebaseApp.configure(options: options)
  }
  
  private func configureGoogleSignIn() {
    guard let clientID = FirebaseApp.app()?.options.clientID else {
      fatalError("No client ID found in Firebase configuration")
    }
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config
  }
}
