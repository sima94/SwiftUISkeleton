//
//  LoginViewModel.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 8.5.25..
//

import Foundation

//protocol LoginViewModelProtocol: AnyObject {
//	var username: FormField<String> { get set }
//	var password: FormField<String> { get set }
//	var isLoginInProgress: Bool { get }
//}

@Observable
final class LoginViewModel {

	@ObservationIgnored
	@FormField(rules: [StringLengthRule.required()], autoValidate: false)
	var username: String = ""

	@ObservationIgnored
	@FormField(rules: [StringLengthRule.required(), StringLengthRule.password()], autoValidate: true)
	var password: String = ""

	var isLoginInProgress: Bool = false

	@ObservationIgnored
	var formValidator = FormValidator()

	@Inject
	@ObservationIgnored
	var loginManager: LoginManager

	@Inject(.flow(.authentication))
	@ObservationIgnored
	var authenticationService: AuthenticationServiceProtocol

	var finishLogin: () -> Void

	init(finishLogin: @escaping () -> Void) {
		self.finishLogin = finishLogin
		formValidator.register(_username)
		formValidator.register(_password)
	}

	@MainActor
	func login() async {
		guard !isLoginInProgress else { return }
		guard formValidator.validate() else { return }
		isLoginInProgress = true
		defer { isLoginInProgress = false }
		do {
			try await authenticationService.loginUser(username: username, password: password)
		} catch {
			log.debug("Login error: \(error)")
		}
		finishLogin()
	}
}
