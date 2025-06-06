//
//  SearchCoordinatorView.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 7.5.25..
//

import SwiftUI

struct SearchCoordinatorView: View {

	var body: some View {
		NavigationStack {
			SearchListView(
				viewModel: SearchListViewModel()
			)
		}
	}
}

#Preview {
	SearchCoordinatorView()
}
