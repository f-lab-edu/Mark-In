//
//  MarkTextField.swift
//  DesignSystem
//
//  Created by 이정동 on 6/9/25.
//

import SwiftUI

#if os(macOS)
public struct MarkTextField: View {
  
  @Binding var text: String
  let placeholder: String
  
  public init(
    text: Binding<String>,
    placeholder: String = ""
  ) {
    self._text = text
    self.placeholder = placeholder
  }
  
  public var body: some View {
    TextField("", text: $text, prompt: Text(placeholder))
      .textFieldStyle(.roundedBorder)
  }
}

#Preview {
  @Previewable @State var text = ""
  MarkTextField(text: $text, placeholder: "입력")
}
#endif
