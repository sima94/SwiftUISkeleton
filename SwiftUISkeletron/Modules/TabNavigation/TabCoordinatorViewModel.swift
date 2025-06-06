//
//  TabCoordinatorViewModel.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 20.5.25..
//

import Foundation
import Combine

protocol TabCoordinatorViewModelProtocol {
	var isLoggedIn: Bool { get }
}

@Observable
class TabCoordinatorViewModel: TabCoordinatorViewModelProtocol {

	@Inject
	@ObservationIgnored
	var loginManager: LoginManager

	var isLoggedIn: Bool = false

	private var cancellables = Set<AnyCancellable>()

	init() {
		loginManager.$isLoggedIn
			.receive(on: DispatchQueue.main)
			.assign(to: \.isLoggedIn, on: self)
			.store(in: &cancellables)
	}
}
