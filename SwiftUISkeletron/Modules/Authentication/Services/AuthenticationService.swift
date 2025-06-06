//
//  AuthenticationService.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 27.5.25..
//

import Foundation

final class AuthenticationService: AuthenticationServiceProtocol {

	let userSession: UserSessionProtocol
	let networkService: NetworkingServiceProtocol

	init(networkService: NetworkingServiceProtocol, userSession: UserSessionProtocol) {
		self.userSession = userSession
		self.networkService = networkService
	}

	func registerUser(_ user: RegisterUser) async throws {
		let registerRequest = try RegisterRequest(registerUser: user)
		try await networkService.execute(registerRequest)
	}

	func loginUser(username: String, password: String) async throws {
		let loginUser = LoginUser(username: username, password: password)
		let loginRequest = try LoginRequest(loginUser: loginUser)
		userSession.token.send(OAuthToken(accessToken: "token", refreshToken: "refreshToken"))
		let response = try await networkService.fetchRequest(loginRequest)
		userSession.token.send(OAuthToken(accessToken: response.token, refreshToken: response.refreshToken))
	}
}
