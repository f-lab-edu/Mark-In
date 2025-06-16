//
//  LinkListView.swift
//  Mark-In
//
//  Created by 이정동 on 4/12/25.
//

import SwiftUI

import DesignSystem
import ReducerKit

private enum ViewConstants {
  static let cellWidth: CGFloat = 210
  static let cellHeight: CGFloat = 160
  static let spacing: CGFloat = 14
}

struct LinkListView: View {
  
  let store: Store<MainReducer>
  
  private var links: [WebLink] {
    let totalLinks = store.state.links
    let tab = store.state.selectedTab ?? .total
    
    switch tab {
    case .total:
      return totalLinks
    case .pin:
      return totalLinks.filter { $0.isPinned }
    case .nonRead:
      return totalLinks.filter { $0.lastAccessedAt == nil }
    case .folder(let folder):
      return totalLinks.filter { $0.folderID == folder.id }
    }
  }
  
  var body: some View {
    GeometryReader { geometry in
      let columns = getColumns(from: geometry.size.width)
      
      ScrollView(.vertical) {
        LazyVGrid(
          columns: columns,
          alignment: .leading,
          spacing: ViewConstants.spacing
        ) {
          ForEach(links, id: \.self) { link in
            LinkCell(
              store: store,
              link: link
            )
          }
        }
        .padding(20)
      }
    }
  }
  
  private func getColumns(from width: Double) -> [GridItem] {
    let cellWidth = ViewConstants.cellWidth
    let spacing = ViewConstants.spacing
    let numberOfColumns = max(
      Int((width + spacing) / (cellWidth + spacing)), 1
    )
    
    return Array(
      repeating: GridItem(
        .flexible(
          minimum: cellWidth,
          maximum: cellWidth
        ),
        spacing: spacing),
      count: numberOfColumns
    )
  }
}

private struct LinkCell: View {
  
  let store: Store<MainReducer>
  let link: WebLink
  
  var body: some View {
    ZStack(alignment: .bottom) {
      Link(destination: URL(string: link.url)!) {
        AsyncImage(
          url: URL(string: link.thumbnailUrl ?? "")
        ) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
        } placeholder: {
          Rectangle()
            .fill(.markWhite70)
        }
        .frame(width: ViewConstants.cellWidth, height: ViewConstants.cellHeight)
      }
      
      VStack(alignment: .leading, spacing: 0) {
        headerTitle
        
        bodyTitle
          .padding(.top, 1)
        
        footerTitle
          .padding(.top, 7)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding(.horizontal, 10)
      .padding([.top, .bottom], 12)
      .background(.markWhite)
    }
    .markRoundedOutline(
      cornerRadius: 6,
      lineWidth: 0.5,
      lineColor: .markBlack20
    )
    .contextMenu {
      Button {
        store.send(.deleteLinkButtonTapped(link: link))
      } label: {
        Text("삭제")
      }
    }
  }
  
  private var headerTitle: some View {
    HStack(alignment: .top, spacing: 3) {
      if link.isPinned {
        Image(systemName: "star.fill")
          .resizable()
          .foregroundStyle(.markPoint)
          .frame(width: 12, height: 12)
      }
      
      Text(link.title ?? "제목 없음")
        .font(.pretendard(size: 12, weight: .semiBold))
        .foregroundStyle(.markBlack)
        .lineLimit(1)
    }
  }
  
  private var bodyTitle: some View {
    Text(link.url)
      .font(.pretendard(size: 10, weight: .regular))
      .foregroundStyle(.markBlack40)
      .lineLimit(1)
  }
  
  private var footerTitle: some View {
    HStack(alignment: .center, spacing: 4) {
      if link.lastAccessedAt == nil {
        Circle()
          .fill(.markRed)
          .frame(width: 5, height: 5)
      }
      
      Text(link.createdAt.description)
        .font(.pretendard(size: 10, weight: .regular))
        .foregroundStyle(.markBlack40)
        .lineLimit(1)
    }
  }
}

#Preview {
  let store: Store<MainReducer> = .init(
    initialState: MainReducer.State(),
    reducer: MainReducer()
  )
  LinkCell(
    store: store,
    link: .init(
      id: "",
      url: "www.naver.com",
      isPinned: true,
      createdAt: .now
    )
  )
    .frame(width: 210, height: 160)
//  LinkListView(viewModel: MainViewModel())
//    .frame(width: 600, height: 600)
}
