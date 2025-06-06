//
//  HomeViewModel.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 29.4.25..
//

import Foundation

@Observable
final class HomeListViewModel: HomeListViewModelProtocol {

	var title = "Hello, World!"
	var isLoading = false
	var data: [HomeListData] = []
	var error: Error?

	@Inject
	@ObservationIgnored
	var homeService: HomeNetworkServiceProtocol

	@MainActor
	func fetchData() async {
		guard !isLoading else { return }
		isLoading = true
		defer { isLoading = false }
		try? await Task.sleep(for: .seconds(2))
		do {
			let data = try await homeService.fetchHomeListData()
			self.data = data
		} catch {
			self.error = error
		}
	}

}
