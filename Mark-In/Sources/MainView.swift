//
//  ContentView.swift
//  Mark-In
//
//  Created by 이정동 on 3/22/25.
//

import SwiftUI
import DesignSystem

struct MainView: View {
  @State private var selectedIndex: Int? = 1
  
  var body: some View {
    NavigationSplitView {
      SideBar(selectedIndex: $selectedIndex)
        .navigationSplitViewColumnWidth(min: 200, ideal: 200, max: 300)
    } detail: {
      VStack {
        Image(.sampleImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .foregroundStyle(.tint)
        
        Text("Hello, world! \(selectedIndex)")
          .font(.pretendard(size: 30, weight: .black))
          .foregroundStyle(.sampleColor)
        Text("Hello, world!")
          .font(.system(size: 30, weight: .black))
        
      }
      .padding()
    }
  }
}

private struct SideBar: View {
  @Binding var selectedIndex: Int?
  
  var body: some View {
    VStack(alignment: .leading) {
      List(selection: $selectedIndex) {
        NavigationLink(value: 1) {
          Label("전체", systemImage: "clock")
        }
        
        NavigationLink(value: 2) {
          Label("즐겨찾기", systemImage: "star")
        }
        
        NavigationLink(value: 3) {
          Label("읽지 않음", systemImage: "xmark.circle")
        }
        
        Section("저장된 폴더") {
          NavigationLink(value: 4) {
            Label("폴더1", systemImage: "folder")
          }
          NavigationLink(value: 5) {
            Label("폴더2", systemImage: "folder")
          }
          NavigationLink(value: 6) {
            Label("폴더3", systemImage: "folder")
          }
        }
      }
      
      Spacer()
      
      Divider()
        .padding(.horizontal, 10)
        .foregroundStyle(.blue)
      
      Button(action: {
        
      }, label: {
        Label("새로운 폴더 만들기", systemImage: "plus")
          .lineLimit(1)
          .padding(5)
      })
      .padding([.bottom, .leading], 10)
    }
    .buttonStyle(.plain)
  }
}

#Preview {
  MainView()
}
