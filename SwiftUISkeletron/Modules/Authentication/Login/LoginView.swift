//
//  LoginView.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 8.5.25..
//

import SwiftUI

struct LoginView: View {

	@State var viewModel: LoginViewModel
	var showRegister: () -> Void

	var body: some View {
		VStack {
			Form {
				Text("Login")
				TextField("Username", text: $viewModel.username)
				if let error = viewModel.$username.error?.message {
					Text(error).foregroundColor(.red)
				}

				TextField("Password", text: $viewModel.password)
				if let error = viewModel.$password.error?.message {
					Text(error).foregroundColor(.red)
				}

				Spacer(minLength: 200)
				Text("Test")
			}

			VStack(spacing: 20) {
				Button(action: {
					Task {
						await viewModel.login()
					}
				}) {
					VStack {
						if viewModel.isLoginInProgress {
							ProgressView()
						} else {
							Text("Login")
						}
					}
					.padding()
					.frame(maxWidth:.infinity)
				}
				.tint(.white)
				.background(.blue)

				Button(action: {
					showRegister()
				}) {
					Text("Go to Register")
						.padding()
						.frame(maxWidth:.infinity)
				}
				.tint(.white)
				.background(.blue)
			}
			.padding(.horizontal, 20)
			.padding(.bottom, 20)

		}
		.loadingOverlay(viewModel.isLoginInProgress)
		.animation(.easeInOut, value: viewModel.isLoginInProgress)
	}
}

//#Preview {
//	LoginView(viewModel: LoginViewModel(navigationDelegate: LoginViewNavigationDelegatePreview()))
//}
