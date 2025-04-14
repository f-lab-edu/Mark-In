//
//  ContentView.swift
//  Mark-In
//
//  Created by 이정동 on 3/22/25.
//

import SwiftUI
import DesignSystem

struct ContentView: View {
  var body: some View {
    VStack {
      Image(.sampleImage)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .foregroundStyle(.tint)
      
      Text("Hello, world!")
        .font(.pretendard(size: 30, weight: .black))
        .foregroundStyle(.sampleColor)
      Text("Hello, world!")
        .font(.system(size: 30, weight: .black))
      
    }
    .padding()
    
  }
}

#Preview {
  ContentView()
}
