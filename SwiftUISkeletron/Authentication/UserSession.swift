//
//  UserSession.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 8.5.25..
//

import Foundation
import Combine

protocol UserSessionProtocol: AnyObject, RequestAdapter {
	var token: CurrentValueSubject<OAuthToken?, Never> { get set}
}

final class UserSession: UserSessionProtocol {

	@Keychain(key: "token")
	var storedToken: OAuthToken?

	var token: CurrentValueSubject<OAuthToken?, Never>

	private var cancellables = Set<AnyCancellable>()

	init() {
		token = .init(nil)
		token.send(storedToken)
		token.sink { [weak self] token in
			self?.storedToken = token
		}.store(in: &cancellables)
	}

}

extension UserSession: RequestAdapter {

	func adapt(_ urlRequest: URLRequest, for session: URLSession) async -> URLRequest {
		var urlRequest = urlRequest
		
		urlRequest.allHTTPHeaderFields?["Authorization"] = "Bearer \(token.value?.refreshToken ?? "")"

		return urlRequest
	}
}
