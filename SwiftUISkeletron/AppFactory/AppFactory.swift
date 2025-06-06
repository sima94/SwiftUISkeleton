//
//  AppFactory.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 8.5.25..
//

import Foundation
import SwiftyBeaver

let log = SwiftyBeaver.self

final class AppFactory {

	var dependencyContainer: DependencyContainer
	var processInfo: ProcessInfo

	init(dependencyContainer: DependencyContainer = .shared, processInfo: ProcessInfo = .processInfo) {
		self.dependencyContainer = dependencyContainer
		self.processInfo = processInfo
	}

	func registerDependences() {

		// SwiftyBeaver setup
		let console = ConsoleDestination()
		console.logPrintWay = .print
		log.addDestination(console)

		dependencyContainer.register(type: UserSessionProtocol.self, UserSession())
		dependencyContainer.register(type: LoginManager.self, LoginManager())

		let userSession = dependencyContainer.resolve(.app, UserSessionProtocol.self)!
		let loginManager = dependencyContainer.resolve(.app, LoginManager.self)

		dependencyContainer.register(type: NetworkingServiceProtocol.self, self.makeNetworkingService(requestAdapter: userSession, requestRetrier: loginManager))

		dependencyContainer.register(
			type: AuthenticationServiceProtocol.self,
			AuthenticationService(
				networkService: self.makeNetworkingService(),
				userSession: userSession))

		dependencyContainer.register(type: HomeNetworkServiceProtocol.self, HomeNetworkService())
	}

	func makeNetworkingService(endpoint: Endpoint = Environment.default.endpoint, requestAdapter: RequestAdapter? = nil, requestRetrier: RequestRetrier? = nil) -> NetworkingServiceProtocol {
		NetworkingService(endpoint: endpoint, requestAdapter: requestAdapter, requestRetrier: requestRetrier)
	}
}
