//
//  ProfileViewModel.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 7.5.25..
//

import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {

	@Inject var loginManager: LoginManager

	@Published var isLoggedIn: Bool = false

	private var cancellables = Set<AnyCancellable>()

	init() {
		loginManager.$isLoggedIn
			.receive(on: DispatchQueue.main)
			.sink { value in
			self.isLoggedIn = value
		}.store(in: &cancellables)
	}

	func logout() {
		loginManager.logout()
	}
}
