//
//  File.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 29.4.25..
//
import Foundation

extension Error {
	static var unknownNetworkingError: Error {
		NetworkingError(message: "UnknownError")
	}
}
