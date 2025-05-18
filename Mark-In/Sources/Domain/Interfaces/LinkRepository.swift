//
//  LinkRepository.swift
//  Mark-In
//
//  Created by 이정동 on 4/20/25.
//

import Foundation

protocol LinkRepository {
  func create(userID: String, link: WriteLink) async throws -> WebLink
  func fetchAll(userID: String) async throws -> [WebLink]
  func update(userID: String, link: WebLink) async throws
  func delete(userID: String, link: WebLink) async throws
}
