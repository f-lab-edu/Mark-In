//
//  AppDelegate.swift
//  Mark-In
//
//  Created by 이정동 on 5/1/25.
//

import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
  func applicationDidFinishLaunching(_ notification: Notification) {
    if let window = NSApplication.shared.windows.first {
      window.backgroundColor = .clear // 윈도우 툴바 배경색을 clear로
    }
  }
}
