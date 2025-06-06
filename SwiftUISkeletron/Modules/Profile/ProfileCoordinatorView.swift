//
//  ProfileCoordinatorView.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 7.5.25..
//

import SwiftUI

struct ProfileCoordinatorView: View {

	enum Route: Hashable {
		case settings
		case authentication(AuthenticationCoordinatorView.InitialScreen)
	}

	@State var path = NavigationPath()

	var body: some View {
		NavigationStack(path: $path) {
			ProfileView(
				viewModel: ProfileViewModel(),
				showLogin: {
					path.append(Route.authentication(.login))
				},
				showRegister: {
					path.append(Route.authentication(.register))
				},
				showSettings: {
					path.append(Route.settings)
				}
			).navigationDestination(for: Route.self) { route in
				switch route {
					case .settings:
						makeSettingsView()
					case .authentication(let initialScreen):
						makeAuthenticationView(initialScreen: initialScreen)
				}
			}
		}
	}
}

private extension ProfileCoordinatorView {
	func makeSettingsView() -> some View {
		ProfileSettingsView()
	}

	func makeAuthenticationView(initialScreen: AuthenticationCoordinatorView.InitialScreen) -> AuthenticationCoordinatorView {
		AuthenticationCoordinatorView(path: $path, initialScreen: initialScreen)
	}
}

#Preview {
	ProfileCoordinatorView()
}
