//
//  LinkRepository.swift
//  Mark-In
//
//  Created by 이정동 on 4/20/25.
//

import Foundation

protocol LinkRepository {
  func createLink(_ link: Link) async throws -> Link
  func fetchAllLinks() async throws -> [Link]
  func updateLink(_ link: Link) async throws
  func deleteLink(_ link: Link) async throws
}
