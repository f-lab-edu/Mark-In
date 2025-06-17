//
//  DeleteFolderUseCaseTests.swift
//  Mark-In-Tests
//
//  Created by 이정동 on 6/6/25.
//

import Testing

@testable import Mark_In

struct DeleteFolderUseCaseTests {
  
  @Test
  func test_인증된_유저_정보가_없을_때_unauthenticated_에러를_반환한다() async throws {
    // Given: 준비
    let stubAuthUserManager = StubAuthUserManager(userID: nil)
    let mockLinkRepository = MockLinkRepository()
    let mockFolderRepository = MockFolderRepository()
    
    let sut = DeleteFolderUseCaseImpl(
      authUserManager: stubAuthUserManager,
      linkRepository: mockLinkRepository,
      folderRepository: mockFolderRepository
    )
    
    // When: 실행
    var thrownError: Error?
    do {
      try await sut.execute(folderID: "", includingChildren: false)
    } catch {
      thrownError = error
    }

    // Then: 검증
    #expect(thrownError as? AuthError == AuthError.unauthenticated)
    
    // TearDown: 해제
    
  }
  
  @Test
  func test_인증된_유저_정보가_있다면_에러를_반환하지_않는다() async throws {
    // Given: 준비
    let stubAuthUserManager = StubAuthUserManager(userID: "testUser")
    let mockLinkRepository = MockLinkRepository()
    let mockFolderRepository = MockFolderRepository()
    
    let sut = DeleteFolderUseCaseImpl(
      authUserManager: stubAuthUserManager,
      linkRepository: mockLinkRepository,
      folderRepository: mockFolderRepository
    )
    
    // When: 실행
    var thrownError: Error?
    do {
      try await sut.execute(folderID: "", includingChildren: false)
    } catch {
      thrownError = error
    }

    // Then: 검증
    #expect(thrownError as? AuthError == nil)
    
    // TearDown: 해제
    
  }
  
  @Test
  func test_includeChildren이_true이면_linkRepository의_deleteAllInFolder를_호출한다() async throws {
    // Given: 준비
    let stubAuthUserManager = StubAuthUserManager(userID: "testUser")
    let mockLinkRepository = MockLinkRepository()
    let mockFolderRepository = MockFolderRepository()
    
    let sut = DeleteFolderUseCaseImpl(
      authUserManager: stubAuthUserManager,
      linkRepository: mockLinkRepository,
      folderRepository: mockFolderRepository
    )
    
    // When: 실행
    try await sut.execute(folderID: "", includingChildren: true)
    
    // Then: 검증
    let deleteAllInFolderCallCount = mockLinkRepository.deleteAllInFolderCallCount
    #expect(deleteAllInFolderCallCount == 1)
    
    // TearDown: 해제
    
  }
  
  @Test
  func test_includeChildren이_false이면_linkRepository의_moveLinksInFolder를_호출한다() async throws {
    // Given: 준비
    let stubAuthUserManager = StubAuthUserManager(userID: "testUser")
    let mockLinkRepository = MockLinkRepository()
    let mockFolderRepository = MockFolderRepository()
    
    let sut = DeleteFolderUseCaseImpl(
      authUserManager: stubAuthUserManager,
      linkRepository: mockLinkRepository,
      folderRepository: mockFolderRepository
    )
    
    // When: 실행
    try await sut.execute(folderID: "", includingChildren: false)
    
    // Then: 검증
    let moveLinksInFolderCallCount = mockLinkRepository.moveLinksInFolderCallCount
    #expect(moveLinksInFolderCallCount == 1)
    
    // TearDown: 해제
    
  }
  
  @Test
  func test_폴더ID가_존재할_경우_folderRepository의_delete를_호출한다() async throws {
    // Given: 준비
    let stubAuthUserManager = StubAuthUserManager(userID: "testUser")
    let mockLinkRepository = MockLinkRepository()
    let mockFolderRepository = MockFolderRepository()
    
    let sut = DeleteFolderUseCaseImpl(
      authUserManager: stubAuthUserManager,
      linkRepository: mockLinkRepository,
      folderRepository: mockFolderRepository
    )
    
    // When: 실행
    try await sut.execute(folderID: "testFolder", includingChildren: false)
    
    // Then: 검증
    let deleteCallCount = mockFolderRepository.deleteCallCount
    #expect(deleteCallCount == 1)
    
    // TearDown: 해제
    
  }
  
  @Test
  func test_폴더ID가_존재하지_않을_경우_folderRepository의_delete를_호출하지_않는다() async throws {
    // Given: 준비
    let stubAuthUserManager = StubAuthUserManager(userID: "testUser")
    let mockLinkRepository = MockLinkRepository()
    let mockFolderRepository = MockFolderRepository()
    
    let sut = DeleteFolderUseCaseImpl(
      authUserManager: stubAuthUserManager,
      linkRepository: mockLinkRepository,
      folderRepository: mockFolderRepository
    )
    
    // When: 실행
    try await sut.execute(folderID: nil, includingChildren: false)
    
    // Then: 검증
    let deleteCallCount = mockFolderRepository.deleteCallCount
    #expect(deleteCallCount == 0)
    
    // TearDown: 해제
    
  }
  

  @Test
  func test_includingChildren이_true면_링크들을_삭제한다() async throws {
    // Given: 준비
    let userID = "testUser"
    let folderID = "testFolderID"
    
    let stubAuthUserManager = StubAuthUserManager(userID: userID)
    let fakeLinkRepo = FakeLinkRepository()
      .withTestLinks(userID: userID, folderID: folderID, count: 5)
    let fakeFolderRepo = FakeFolderRepository()
      .withTestFolder(userID: userID, folderID: folderID)
      .withTestFolders(userID: userID, count: 2)
    
    let sut = DeleteFolderUseCaseImpl(
      authUserManager: stubAuthUserManager,
      linkRepository: fakeLinkRepo,
      folderRepository: fakeFolderRepo
    )
    
    // When: 실행
    _ = try await sut.execute(folderID: folderID, includingChildren: true)
    
    // Then: 검증
    let links = fakeLinkRepo.data[userID]!
    
    #expect(links.filter { $0.folderID == folderID }.isEmpty)
    
    // TearDown: 해제
    
  }

  @Test
  func test_includingChildren이_false면_링크들을_기본_폴더로_이동한다() async throws {
    // Given: 준비
    let userID = "testUser"
    let folderID = "testFolderID"
    let defaultFolderID: String? = nil
    
    let stubAuthUserManager = StubAuthUserManager(userID: userID)
    let fakeLinkRepo = FakeLinkRepository()
      .withTestLinks(userID: userID, folderID: folderID, count: 5)
    let fakeFolderRepo = FakeFolderRepository()
      .withTestFolder(userID: userID, folderID: folderID)
      .withTestFolder(userID: userID, folderID: defaultFolderID)
    
    let sut = DeleteFolderUseCaseImpl(
      authUserManager: stubAuthUserManager,
      linkRepository: fakeLinkRepo,
      folderRepository: fakeFolderRepo
    )
    
    // When: 실행
    _ = try await sut.execute(folderID: folderID, includingChildren: false)
    
    // Then: 검증
    let links = fakeLinkRepo.data[userID]!
    
    #expect(links.filter { $0.folderID == defaultFolderID }.count == 5)
    
    // TearDown: 해제
    
  }
  
  @Test
  func test_folderID가_nil이면_폴더는_삭제되지_않는다() async throws {
    // Given: 준비
    let userID = "testUser"
    let folderID: String? = nil
    
    let stubAuthUserManager = StubAuthUserManager(userID: userID)
    let fakeLinkRepo = FakeLinkRepository()
      .withTestLinks(userID: userID, folderID: folderID, count: 5)
    let fakeFolderRepo = FakeFolderRepository()
      .withTestFolder(userID: userID, folderID: folderID)
    
    let sut = DeleteFolderUseCaseImpl(
      authUserManager: stubAuthUserManager,
      linkRepository: fakeLinkRepo,
      folderRepository: fakeFolderRepo
    )
    
    // When: 실행
    _ = try await sut.execute(folderID: folderID, includingChildren: false)
    
    // Then: 검증
    let folders = fakeFolderRepo.data[userID]!
    
    #expect(folders.contains { $0.id == folderID })
    
    // TearDown: 해제
    
  }
  
  @Test
  func test_folderID가_존재하면_폴더를_삭제한다() async throws {
    // Given: 준비
    let userID = "testUser"
    let folderID = "testFolder"
    
    let stubAuthUserManager = StubAuthUserManager(userID: userID)
    let fakeLinkRepo = FakeLinkRepository()
      .withTestLinks(userID: userID, folderID: folderID, count: 5)
    let fakeFolderRepo = FakeFolderRepository()
      .withTestFolder(userID: userID, folderID: folderID)
    
    let sut = DeleteFolderUseCaseImpl(
      authUserManager: stubAuthUserManager,
      linkRepository: fakeLinkRepo,
      folderRepository: fakeFolderRepo
    )
    
    // When: 실행
    _ = try await sut.execute(folderID: folderID, includingChildren: false)
    
    // Then: 검증
    let folders = fakeFolderRepo.data[userID]!
    
    #expect(folders.contains { $0.id == folderID } == false)
    
    // TearDown: 해제
    
  }
}
