//
//  MarkCancelButton.swift
//  DesignSystem
//
//  Created by 이정동 on 6/7/25.
//

import SwiftUI

#if os(macOS)
public struct MarkCancelButton: View {
  private let action: () -> Void
  
  public init(_ action: @escaping () -> Void) {
    self.action = action
  }
  
  public var body: some View {
    Button {
      action()
    } label: {
      Text("취소")
        .padding(.vertical, 4)
        .padding(.horizontal, 14)
        .foregroundStyle(.markBlack)
        .background(.markWhite)
        .font(.pretendard(size: 14, weight: .medium))
        .markRoundedOutline(
          cornerRadius: 6,
          lineWidth: 0.5,
          lineColor: .markBlack10
        )
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  MarkCancelButton {
    
  }
}
#endif
