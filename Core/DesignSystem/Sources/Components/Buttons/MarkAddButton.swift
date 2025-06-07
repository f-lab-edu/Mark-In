//
//  MarkAddButton.swift
//  DesignSystem
//
//  Created by 이정동 on 6/7/25.
//

import SwiftUI

#if os(macOS)
public struct MarkAddButton: View {
  
  private let action: () -> Void
  
  public init(_ action: @escaping () -> Void) {
    self.action = action
  }
  
  public var body: some View {
    Button {
      action()
    } label: {
      Text("추가")
        .padding(.vertical, 4)
        .padding(.horizontal, 14)
        .foregroundStyle(.markWhite)
        .background(.markPoint)
        .font(.pretendard(size: 14, weight: .medium))
        .markRoundedOutline(cornerRadius: 6)
    }
    .buttonStyle(.plain)
  }
}


#Preview {
  MarkAddButton {
    
  }
}
#endif
