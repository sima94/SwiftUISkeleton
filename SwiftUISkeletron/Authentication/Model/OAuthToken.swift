//
//  OAuthToken.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 27.5.25..
//

import Foundation

final class OAuthToken: Codable, Hashable {

	var accessToken: String
	var refreshToken: String

	init(accessToken: String, refreshToken: String) {
		self.accessToken = accessToken
		self.refreshToken = refreshToken
	}

	func hash(into hasher: inout Hasher) {
		accessToken.hash(into: &hasher)
		refreshToken.hash(into: &hasher)
	}

	static func == (lhs: OAuthToken, rhs: OAuthToken) -> Bool {
		lhs.hashValue == rhs.hashValue
	}
}
