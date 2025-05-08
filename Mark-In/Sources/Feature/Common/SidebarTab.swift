//
//  SidebarTab.swift
//  Mark-In
//
//  Created by 이정동 on 4/29/25.
//

import Foundation

enum SidebarTab: Hashable {
  case total
  case pin
  case nonRead
  case folder(Folder)
  
  var title: String {
    switch self {
    case .total: "전체"
    case .pin: "즐겨찾기"
    case .nonRead: "읽지 않음"
    case .folder(let folder): folder.name
    }
  }
  
  var icon: String {
    switch self {
    case .total: "clock"
    case .pin: "star"
    case .nonRead: "xmark.circle"
    case .folder(_): "folder"
    }
  }
  
  var isFolder: Bool {
    if case .folder(_) = self { true }
    else { false }
  }
}
