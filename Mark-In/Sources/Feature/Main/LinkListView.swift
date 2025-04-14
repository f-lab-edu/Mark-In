//
//  LinkListView.swift
//  Mark-In
//
//  Created by 이정동 on 4/12/25.
//

import SwiftUI
import DesignSystem

private struct ViewConstants {
  static let cellWidth: CGFloat = 210
  static let cellHeight: CGFloat = 160
  static let spacing: CGFloat = 14
}

struct LinkListView: View {
  let cellWidth: CGFloat = ViewConstants.cellWidth
  let cellHeight = ViewConstants.cellHeight
  let spacing: CGFloat = ViewConstants.spacing
  
  var body: some View {
    GeometryReader { geometry in
      let width = geometry.size.width
      let numberOfColumns = max(
        Int((width + spacing) / (cellWidth + spacing)),
        1
      )
      
      let columns = Array(
        repeating: GridItem(
          .flexible(minimum: cellWidth, maximum: cellWidth),
          spacing: spacing),
        count: numberOfColumns
      )
      
      ScrollView(.vertical) {
        LazyVGrid(
          columns: columns,
          alignment: .leading,
          spacing: spacing
        ) {
          ForEach((0...19), id: \.self) { _ in
            LinkCell()
              .frame(width: cellWidth, height: cellHeight)
          }
        }
        .padding(20)
      }
    }
  }
}

private struct LinkCell: View {
  
  var body: some View {
    ZStack(alignment: .bottom) {
      Image(.sampleImage)
        .resizable()
        .aspectRatio(contentMode: .fit)
      
      VStack(alignment: .leading, spacing: 4) {
        Text("맛집 링크 - 네이버 지도")
          .font(.pretendard(size: 12, weight: .semiBold))
        Text("7일 전")
          .font(.pretendard(size: 10, weight: .regular))
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding([.top, .horizontal], 10)
      .padding(.bottom, 12)
      .background(.green)
    }
    .background(.yellow)
    .clipShape(
      RoundedRectangle(cornerRadius: 6)
    )
    .overlay(content: {
      RoundedRectangle(cornerRadius: 6)
        .stroke(lineWidth: 0.5)
    })
    
  }
}

#Preview {
  LinkListView()
    .frame(width: 600, height: 600)
}
