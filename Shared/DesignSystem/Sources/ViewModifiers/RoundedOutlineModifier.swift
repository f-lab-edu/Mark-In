//
//  RoundedStrokeModifier.swift
//  DesignSystem
//
//  Created by 이정동 on 6/7/25.
//

import SwiftUI

struct RoundedOutlineModifier: ViewModifier {
  
  let cornerRadius: CGFloat
  let lineWidth: CGFloat
  let lineColor: Color
  
  func body(content: Content) -> some View {
    content
      .clipShape(
        RoundedRectangle(cornerRadius: cornerRadius)
      )
      .overlay(content: {
        RoundedRectangle(cornerRadius: cornerRadius)
          .stroke(lineWidth: lineWidth)
          .fill(lineColor)
      })
  }
}

public extension View {
  func markRoundedOutline(
    cornerRadius: CGFloat,
    lineWidth: CGFloat = 0,
    lineColor: Color = .clear
  ) -> some View {
    self.modifier(
      RoundedOutlineModifier(
        cornerRadius: cornerRadius,
        lineWidth: lineWidth,
        lineColor: lineColor
      )
    )
  }
}
