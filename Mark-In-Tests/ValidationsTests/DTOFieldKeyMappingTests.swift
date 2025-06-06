//
//  Mark_In_Tests.swift
//  Mark-In-Tests
//
//  Created by 이정동 on 6/4/25.
//

import Testing
import TestSupport

@testable import Mark_In

struct DTOFieldKeyMappingTests: BaseTestCase {
  
  @Test
  func test_FolderDTO의_CodingKey와_FirestoreFieldKey가_일치해야_한다() async throws {
    given { }
    
    when { }
    
    then {
      #expect(FolderDTO.CodingKeys.id.rawValue == FirestoreFieldKey.Folder.id)
      #expect(FolderDTO.CodingKeys.name.rawValue == FirestoreFieldKey.Folder.name)
      #expect(FolderDTO.CodingKeys.createdAt.rawValue == FirestoreFieldKey.Folder.createdAt)
    }
  }
  
  @Test
  func test_WebLinkDTO의_CodingKey와_FirestoreFieldKey가_일치해야_한다() async throws {
    given { }
    
    when { }
    
    then {
      #expect(WebLinkDTO.CodingKeys.id.rawValue == FirestoreFieldKey.Link.id)
      #expect(WebLinkDTO.CodingKeys.url.rawValue == FirestoreFieldKey.Link.url)
      #expect(WebLinkDTO.CodingKeys.title.rawValue == FirestoreFieldKey.Link.title)
      #expect(WebLinkDTO.CodingKeys.thumbnailUrl.rawValue == FirestoreFieldKey.Link.thumbnailUrl)
      #expect(WebLinkDTO.CodingKeys.faviconUrl.rawValue == FirestoreFieldKey.Link.faviconUrl)
      #expect(WebLinkDTO.CodingKeys.isPinned.rawValue == FirestoreFieldKey.Link.isPinned)
      #expect(WebLinkDTO.CodingKeys.createdAt.rawValue == FirestoreFieldKey.Link.createdAt)
      #expect(WebLinkDTO.CodingKeys.lastAccessedAt.rawValue == FirestoreFieldKey.Link.lastAccessedAt)
      #expect(WebLinkDTO.CodingKeys.folderID.rawValue == FirestoreFieldKey.Link.folderID)
    }
  }
}
