//
//  DependencyType.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 8.5.25..
//

import Foundation

enum DependencyScope {
	case app
	case newApp
	case new
	case flow(DependencyFlow)
}

enum DependencyFlow {
	case authentication
	case search
}
