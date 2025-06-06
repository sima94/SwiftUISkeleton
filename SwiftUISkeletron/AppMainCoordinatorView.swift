//
//  ContentView.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 29.4.25..
//

import SwiftUI

struct AppMainCoordinatorView: View {
	var body: some View {
		TabCoordinatorView(viewModel: TabCoordinatorViewModel())
	}
}

#Preview {
	AppMainCoordinatorView()
}
