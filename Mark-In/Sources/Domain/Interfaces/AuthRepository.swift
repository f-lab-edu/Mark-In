//
//  AuthRepository.swift
//  Mark-In
//
//  Created by 이정동 on 5/5/25.
//

import Foundation

protocol AuthRepository {
  func fetchCurrentUserID() -> String?
}
