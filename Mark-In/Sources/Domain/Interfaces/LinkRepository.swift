//
//  LinkRepository.swift
//  Mark-In
//
//  Created by 이정동 on 4/20/25.
//

import Foundation

protocol LinkRepository {
  func create(userID: String, link: WriteLink) async throws -> Link
  func fetchAll(userID: String) async throws -> [Link]
  func update(userID: String, link: Link) async throws
  func delete(userID: String, link: Link) async throws
}
