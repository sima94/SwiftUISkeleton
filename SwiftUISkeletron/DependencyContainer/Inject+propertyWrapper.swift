//
//  File.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 8.5.25..
//

import Foundation

@propertyWrapper
struct Inject<Dependency> {

	var dependencyContainer: DependencyContainer = .shared
	var dependency: Dependency

	init(_ scope: DependencyScope = .app) {
		guard let dependency = dependencyContainer.resolve(scope, Dependency.self) else {
			let dependencyName = String(describing: Dependency.self)
			fatalError("No dependency of type \(dependencyName) registered!")
		}

		self.dependency = dependency
	}

	var wrappedValue: Dependency {
		get { self.dependency }
		mutating set { dependency = newValue }
	}
}
