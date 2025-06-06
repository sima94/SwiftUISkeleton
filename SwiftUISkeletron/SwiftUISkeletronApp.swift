//
//  SwiftUISkeletronApp.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 29.4.25..
//

import SwiftUI

@main
struct SwiftUISkeletronApp: App {

	let appFactory = AppFactory()

	init(){
		appFactory.registerDependences()
	}

	var body: some Scene {
		WindowGroup {
			AppMainCoordinatorView()
		}
	}
}
