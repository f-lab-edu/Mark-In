//
//  LinkRepository.swift
//  Mark-In
//
//  Created by 이정동 on 4/20/25.
//

import Foundation

protocol LinkRepository {
  func create(_ link: WriteLink) async throws -> Link
  func fetchAll() async throws -> [Link]
  func update(_ link: Link) async throws
  func delete(_ link: Link) async throws
}
