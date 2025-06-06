//
//  ProcessInfo+Utils.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 13.5.25..
//

import Foundation

extension ProcessInfo {

	var isRunningInPreview: Bool {
		return environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
	}

	var isRunningUITests: Bool {
		return environment["IS_RUNNING_UI_TESTS"] == "YES"
	}
}
