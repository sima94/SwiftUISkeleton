//
//  HomeNetworkService.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 29.4.25..
//

import Foundation

final class HomeNetworkService: HomeNetworkServiceProtocol {

	@Inject var networkService: NetworkingServiceProtocol

	func fetchHomeListData() async throws -> [HomeListData] {
		return [.init(title: "Test1"), .init(title: "Test2"), .init(title: "Test3")]
		//return try await networkService.fetchRequest(HomeFetchRequest())
	}

	func fetchHomeDetailData(id: Int) async throws -> HomeDetailData {
		return HomeDetailData(id: .init(), title: "Title", subtitle: "Subtitle", description: "Description")
	}
}
