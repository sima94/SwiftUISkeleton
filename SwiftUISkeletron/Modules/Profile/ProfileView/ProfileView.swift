//
//  ProfileView.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 29.4.25..
//

import Foundation
import SwiftUI

struct ProfileView: View {

	@StateObject var viewModel: ProfileViewModel
	var showLogin: () -> Void
	var showRegister: () -> Void
	var showSettings: () -> Void

	var body: some View {
		VStack {

			Spacer(minLength: 20)

			Text("Profile")

			Spacer()

			if !viewModel.isLoggedIn {

				Button {
					showLogin()
				} label: {
					Text("Login")
						.padding()
						.frame(maxWidth:.infinity)
				}
				.tint(.white)
				.background(Color.blue)

				Button {
					showRegister()
				} label: {
					Text("Register")
						.padding()
						.frame(maxWidth:.infinity)
				}
				.tint(.white)
				.background(Color.red)
			} else {

				Button {
					viewModel.logout()
				} label: {
					Text("Logout")
						.padding()
						.frame(maxWidth:.infinity)
				}
				.tint(.white)
				.background(Color.cyan)
			}

			Spacer()
		}
		.padding(10)
		//.navigationTitle("Profile")
		//.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button(action: {
					showSettings()
				}) {
					Image(systemName: "person.circle")
				}
			}
		}

	}
}
