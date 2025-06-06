//
//  NetworkingServiceProtocol.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 29.4.25..
//

import Foundation

protocol NetworkingServiceProtocol {
	func fetchRequest<R: HTTPFetchRequest>(_ request: R) async throws -> R.Object
	@discardableResult
	func execute<R: HTTPRequest>(_ request: R) async throws -> (Data, HTTPURLResponse)
}
