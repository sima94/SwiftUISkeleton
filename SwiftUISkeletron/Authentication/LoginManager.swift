//
//  LoginManager.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 8.5.25..
//

import Foundation
import Combine

final class LoginManager {

	@Inject var userSession: UserSessionProtocol

	@Published var isLoggedIn: Bool = false

	private var cancellables = Set<AnyCancellable>()

	init() {
		userSession.token
			.removeDuplicates()
			.map { $0 != nil }
			.assign(to: \.isLoggedIn, on: self)
			.store(in: &cancellables)
	}

	func logout() {
		userSession.token.send(nil)
	}

}

extension LoginManager: RequestRetrier {

	func retry(_ request: URLRequest, httpUrlResponse: HTTPURLResponse, for session: URLSession, dueTo error: any Error) async -> Bool {

		if httpUrlResponse.statusCode == 401 {
			//refresh token and return true
		}

		return false
	}

}
