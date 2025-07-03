//
//  DesignSystem.swift
//  DesignSystem
//
//  Created by 이정동 on 4/8/25.
//


import SwiftUI

public extension Color {
  static let markPoint: Color = .point
  static let markPoint50: Color = .point50
  static let markPoint7: Color = .point7
  
  static let markBlack: Color = .black100
  static let markBlack70: Color = .black70
  static let markBlack40: Color = .black40
  static let markBlack30: Color = .black30
  static let markBlack20: Color = .black20
  static let markBlack10: Color = .black10
  static let markBlack5: Color = .black5
  
  static let markWhite: Color = .white100
  static let markWhite70: Color = .white70
  static let markWhite50: Color = .white50
  
  static let markRed: Color = .red100
  static let markRed7: Color = .red7
  
  static let markBackground: Color = .background
}

public extension ShapeStyle where Self == Color {
    
  static var markPoint: Self { .point }
  static var markPoint50: Self { .point50 }
  static var markPoint7: Self { .point7 }
  
  static var markBlack: Self { .black100 }
  static var markBlack70: Self { .black70 }
  static var markBlack40: Self { .black40 }
  static var markBlack30: Self { .black30 }
  static var markBlack20: Self { .black20 }
  static var markBlack10: Self { .black10 }
  static var markBlack5: Self { .black5 }
  
  static var markWhite: Self { .white100 }
  static var markWhite70: Self { .white70 }
  static var markWhite50: Self { .white50 }
  
  static var markRed: Self { .red100 }
  static var markRed7: Self { .red7 }
  
  static var markBackground: Self { .background }
}

public extension LinearGradient {
  static let background = Self(
    colors: [.backgroundLinearTop, .background],
    startPoint: .top,
    endPoint: .bottom
  )
  
  static let button = Self(
    colors: [.buttonLinearTop, .buttonLinearBottom],
    startPoint: .top,
    endPoint: .bottom
  )
}
