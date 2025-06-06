//
//  Bundle+Utils.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 7.5.25..
//
import Foundation

extension Bundle {

	var releaseVersionNumber: String {
		object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
	}

	var buildVersionNumber: String {
		object(forInfoDictionaryKey: "CFBundleVersion") as! String
	}

	var env: [String: String] {
		object(forInfoDictionaryKey: "ENV") as! [String: String]
	}
}
