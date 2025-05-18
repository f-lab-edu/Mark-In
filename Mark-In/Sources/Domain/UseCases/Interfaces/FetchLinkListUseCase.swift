//
//  FetchLinkListUseCase.swift
//  Mark-In
//
//  Created by 이정동 on 5/11/25.
//

import Foundation

protocol FetchLinkListUseCase {
  func execute(userID: String) async throws -> [WebLink]
}
