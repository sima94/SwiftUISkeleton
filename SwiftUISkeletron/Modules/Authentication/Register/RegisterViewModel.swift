//
//  RegisterViewModel.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 8.5.25..
//

import Foundation

@Observable
final class RegisterViewModel {

	var username: String = ""
	var firstName: String = ""
	var lastName: String = ""
	var password: String = ""
	var email: String = ""
	var isLoading: Bool = false

	@Inject(.flow(.authentication))
	@ObservationIgnored
	var authenticationService: AuthenticationServiceProtocol

	@MainActor
	func register() async {
		isLoading = true
		defer { isLoading = false }

		do {
			try await authenticationService.registerUser(.init(username: username, firstName: firstName, lastName: lastName, email: email, password: password))
		} catch {

		}
	}
}
