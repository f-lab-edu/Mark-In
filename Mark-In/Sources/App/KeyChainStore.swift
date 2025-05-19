//
//  KeyChainStore.swift
//  Mark-In
//
//  Created by 이정동 on 5/14/25.
//




// TODO: Core 모듈로 이동

import Foundation
import Security

enum KeychainError: Error {
  case encodingFailed
  case decodingFailed
  case unexpectedStatus(OSStatus)
}

protocol KeychainStore {
  func save<T: Codable>(_ value: T, forKey key: String) throws
  func load<T: Codable>(forKey key: String) throws -> T?
  func delete(forKey key: String) throws
}

struct KeychainStoreImpl: KeychainStore {
  
  func save<T: Codable>(_ value: T, forKey key: String) throws {
    let data: Data
    do {
      data = try JSONEncoder().encode(value)
    } catch {
      throw KeychainError.encodingFailed
    }
    
    // 기존 항목 삭제 후 저장
    try delete(forKey: key)
    
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecValueData as String: data
    ]
    
    let status = SecItemAdd(query as CFDictionary, nil)
    guard status == errSecSuccess else {
      throw KeychainError.unexpectedStatus(status)
    }
  }
  
  func load<T: Codable>(forKey key: String) throws -> T? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne
    ]
    
    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw KeychainError.unexpectedStatus(status)
    }
    
    guard let data = result as? Data else { return nil }
    
    do {
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      throw KeychainError.decodingFailed
    }
  }
  
  func delete(forKey key: String) throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key
    ]
    
    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw KeychainError.unexpectedStatus(status)
    }
  }
}
