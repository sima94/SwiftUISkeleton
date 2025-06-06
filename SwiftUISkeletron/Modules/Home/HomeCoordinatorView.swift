//
//  HomeNavigationCoordinatorView.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 29.4.25..
//

import SwiftUI

struct HomeCoordinatorView: View {

	enum Route: Hashable {
		case homeDetails(HomeListData)
	}

	@State var path = NavigationPath()
	@State var isPresentedHomeDetailsSheet: Bool = false

	var body: some View {
		NavigationStack(path: $path) {
			HomeListView(viewModel: HomeListViewModel(), showHomeDetails: {
					path.append(Route.homeDetails($0))
				}
			)
			.navigationDestination(for: Route.self) { route in
				switch route {
					case .homeDetails(_):
						makeHomeDetailsView()
							.sheet(isPresented: $isPresentedHomeDetailsSheet) {
								HomeDetailsSheetView()
							}
				}
			}
		}
	}
}

private extension HomeCoordinatorView {

	func makeHomeDetailsView() -> HomeDetailsView {
		HomeDetailsView(
			viewModel: HomeDetailsViewModel(), modalAction: {
				isPresentedHomeDetailsSheet.toggle()
			}
		)
	}

}

#Preview {
	HomeCoordinatorView()
}
