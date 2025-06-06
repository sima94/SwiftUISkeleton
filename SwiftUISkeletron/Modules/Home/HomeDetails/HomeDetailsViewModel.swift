//
//  HomeDetailsViewModel.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 29.4.25..
//

import Foundation
import Observation
import SwiftUICore

@Observable
class HomeDetailsViewModel: HomeDetailsViewModelProtocol {

	var isLoading: Bool = false
	var data: String?

	@Inject
	@ObservationIgnored
	var homeService: HomeNetworkServiceProtocol

	@MainActor
	func fetchData() async {
		isLoading = true
		defer { isLoading = false }
		
		try? await Task.sleep(for: .seconds(2))

		if let item = try? await homeService.fetchHomeDetailData(id: 1) {
			data = item.title + "\n" + item.subtitle + "\n" + item.description
		}
	}
}
