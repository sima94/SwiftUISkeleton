//
//  TabBarCoordinatorView.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 29.4.25..
//

import SwiftUI

struct TabCoordinatorView: View {

	var viewModel: TabCoordinatorViewModelProtocol

	var body: some View {
		TabView {
			HomeCoordinatorView()
				.tabItem {
					Label("Home", systemImage: "house.fill")
				}

			if viewModel.isLoggedIn {
				SearchCoordinatorView()
					.tabItem {
						Label("Search", systemImage: "magnifyingglass")
					}
			}
			
			ProfileCoordinatorView()
				.tabItem {
					Label("Profile", systemImage: "person.fill")
				}
		}
	}
}
