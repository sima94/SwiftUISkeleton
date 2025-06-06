//
//  HomeDetailsView.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 29.4.25..
//

import SwiftUI

struct HomeDetailsView: View {

	var viewModel: HomeDetailsViewModelProtocol
	var modalAction: () -> Void

	var body: some View {
		VStack {
			Text("Hello, Details!")
			if viewModel.isLoading {
				ProgressView()
			} else {
				Text("\(viewModel.data ?? "")")
			}
			Button("Action") {
				modalAction()
			}
		}
		.task {
			await viewModel.fetchData()
		}
	}
}

#Preview {
	HomeDetailsView(viewModel: HomeDetailsViewModelMock(isLoading: false), modalAction: { })
}

#Preview {
	HomeDetailsView(viewModel: HomeDetailsViewModelMock(isLoading: true), modalAction: { })
}

class HomeDetailsViewModelMock: HomeDetailsViewModelProtocol {
	var isLoading: Bool
	var data: String?

	init(isLoading: Bool = false, data: String? = "#Preview Data") {
		self.isLoading = isLoading
		self.data = data
	}

	func fetchData() async { }
}
