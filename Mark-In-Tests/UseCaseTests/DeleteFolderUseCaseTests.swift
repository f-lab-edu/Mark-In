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
