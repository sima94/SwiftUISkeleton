//
//  KeychainStored+propertyWrapper.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 27.5.25..
//

import Foundation
import Security

@propertyWrapper
struct Keychain<Value: Codable> {
	private let key: String
	private let service: String

	init(key: String, service: String = Bundle.main.bundleIdentifier ?? "DefaultService") {
		self.key = key
		self.service = service
	}

	var wrappedValue: Value? {
		get {
			guard let data = readFromKeychain() else { return nil }

			// Special case: Value is String
			if Value.self == String.self, let string = String(data: data, encoding: .utf8) as? Value {
				return string
			}

			// Attempt to decode using JSON
			return try? JSONDecoder().decode(Value.self, from: data)
		}

		set {
			guard let value = newValue else {
				deleteFromKeychain()
				return
			}

			let data: Data

			if let stringValue = value as? String {
				data = Data(stringValue.utf8)
			} else {
				// Encode all other Codable values
				guard let encoded = try? JSONEncoder().encode(value) else { return }
				data = encoded
			}

			saveToKeychain(data: data)
		}
	}

	// MARK: - Keychain Helpers

	private func readFromKeychain() -> Data? {
		let query: [String: Any] = [
			kSecClass as String:           kSecClassGenericPassword,
			kSecAttrAccount as String:     key,
			kSecAttrService as String:     service,
			kSecReturnData as String:      true,
			kSecMatchLimit as String:      kSecMatchLimitOne
		]

		var result: CFTypeRef?
		let status = SecItemCopyMatching(query as CFDictionary, &result)

		guard status == errSecSuccess else { return nil }
		return result as? Data
	}

	private func saveToKeychain(data: Data) {
		let query: [String: Any] = [
			kSecClass as String:       kSecClassGenericPassword,
			kSecAttrAccount as String: key,
			kSecAttrService as String: service
		]

		SecItemDelete(query as CFDictionary)

		var attributes = query
		attributes[kSecValueData as String] = data
		SecItemAdd(attributes as CFDictionary, nil)
	}

	private func deleteFromKeychain() {
		let query: [String: Any] = [
			kSecClass as String:       kSecClassGenericPassword,
			kSecAttrAccount as String: key,
			kSecAttrService as String: service
		]

		SecItemDelete(query as CFDictionary)
	}
}
