//
//  AppContainer.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 29.4.25..
//

import Foundation

public typealias DependencyGroupKey = String

final class DependencyContainer {

	static let shared = DependencyContainer()

	private var factories: [DependencyGroupKey: () -> Any] = [:]
	private var cache: [DependencyGroupKey: Any] = [:]
	private var flowCache: [DependencyFlow: [DependencyGroupKey: WeekContainer<AnyObject>]] = [:]

	func register<Dependency>(type: Dependency.Type, _ factory: @autoclosure @escaping () -> Dependency) {
		factories[DependencyGroupKey(describing: type.self)] = factory
	}

	func resolve<Dependency>(_ resolveScope: DependencyScope = .app, _ type: Dependency.Type) -> Dependency? {
		let serviceName = DependencyGroupKey(describing: type.self)

		switch resolveScope {
			case .app:
				if let service = cache[serviceName] as? Dependency {
					return service
				} else if let service = factories[serviceName]?() as? Dependency {
					cache[serviceName] = service
					return service
				}
				return nil

			case .newApp:
				if let service = factories[serviceName]?() as? Dependency {
					cache[serviceName] = service
					return service
				}
				return nil

			case .new:
				return factories[serviceName]?() as? Dependency

			case .flow(let flow):
				if let container = flowCache[flow]?[serviceName],
					let instance = container.value as? Dependency {
					return instance
				} else if let newService = factories[serviceName]?() as? AnyObject {
					var flowServices = flowCache[flow] ?? [:]
					flowServices[serviceName] = WeekContainer(newService, onDeinit: { [weak self] in
						self?.flowCache[flow]?[serviceName] = nil
					})
					flowCache[flow] = flowServices
					return newService as? Dependency
				}
				return nil
		}
	}

	func clearFlow(_ flow: DependencyFlow) {
		flowCache[flow] = nil
	}
}
