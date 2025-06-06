//
//  AuthenticationCoordinatorView.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 8.5.25..
//

import SwiftUI

struct AuthenticationCoordinatorView: View {

	enum Route: Hashable {
		case register
	}

	@Binding var path:  NavigationPath

	enum InitialScreen {
		case login
		case register
	}

	var initialScreen: InitialScreen = .login

	var body: some View {
		if initialScreen == .login {
			LoginView(viewModel: LoginViewModel(finishLogin: {
				path.removeLast()
			}), showRegister: {
				path.append(Route.register)
			})
			.navigationDestination(for: Route.self) { route in
				switch route {
					case .register:
						makeRegisterView()
				}
			}
		} else {
			RegisterView(viewModel: RegisterViewModel())
		}
	}
}

private extension AuthenticationCoordinatorView {
	func makeRegisterView() -> some View {
		RegisterView(viewModel: RegisterViewModel())
	}
}

//#Preview {
//	AuthenticationCoordinatorView(path: NavigationPath())
//}
