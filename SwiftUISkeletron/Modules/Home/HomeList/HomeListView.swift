//
//  HomeView.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 29.4.25..
//

import Foundation
import SwiftUI

struct HomeListView: View {

	@State var viewModel: HomeListViewModelProtocol
	var showHomeDetails: (HomeListData) -> Void

	var body: some View {
		Group {
			if viewModel.isLoading && viewModel.data.isEmpty {
				ProgressView()
			} else {
				List(viewModel.data) { item in
					Button(item.title, action: {
						showHomeDetails(item)
					})
				}
				.navigationTitle(viewModel.title)
		//		.alert(item: <#T##Binding<Identifiable?>#>) { item in
		//			Alert(title: item.title, message: item.message, primaryButton: item.primaryButton, secondaryButton: item.secondaryButton)
		//		}
			}
		}
		.refreshable {
			Task {
				await viewModel.fetchData()
			}
		}
		.task {
			await viewModel.fetchData()
		}
	}
}

#Preview {
	HomeListView(viewModel:  HomeListViewModelMock(title: "Title", isLoading: true, data: []), showHomeDetails: { _ in })
}

#Preview {
	HomeListView(viewModel:  HomeListViewModelMock(title: "Title", isLoading: false, data: [.init(title: "Test"), .init(title: "Test 2")]), showHomeDetails: { _ in })
}

class HomeListViewModelMock: HomeListViewModelProtocol {
	var title: String
	var isLoading: Bool
	var data: [HomeListData]
	var error: (any Error)?

	init(title: String, isLoading: Bool, data: [HomeListData], error: (any Error)? = nil) {
		self.title = title
		self.isLoading = isLoading
		self.data = data
		self.error = error
	}

	func fetchData() async {

	}
}
