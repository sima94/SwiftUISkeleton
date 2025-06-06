//
//  NetworkingService.swift
//  Srbija Voz
//
//  Created by Darko Stojkovic on 2.12.21..
//

import Foundation

final class NetworkingService: NetworkingServiceProtocol {
	let session: URLSession
	let endpoint: Endpoint
	let requestAdapter: RequestAdapter?
	let requestRetrier: RequestRetrier?

	init(
		session: URLSession = URLSession(configuration: .default, delegate: nil, delegateQueue: .main),
		endpoint: Endpoint,
		requestAdapter: RequestAdapter? = nil,
		requestRetrier: RequestRetrier? = nil
	) {
		self.session = session
		self.endpoint = endpoint
		self.requestAdapter = requestAdapter
		self.requestRetrier = requestRetrier
	}

	func fetchRequest<R: HTTPFetchRequest>(_ request: R) async throws -> R.Object {
		let (data, _) = try await execute(request)
		return try request.decoder.decode(R.Object.self, from: data)
	}

	@discardableResult
	func execute<R: HTTPRequest>(_ request: R) async throws -> (Data, HTTPURLResponse) {
		let urlRequest = try await urlRequest(request)
		var (data, httpUrlResponse): (Data, HTTPURLResponse)
		do {
			(data, httpUrlResponse) = try await self.session.perform(urlRequest)
			logToConsole(httpRequest: urlRequest, httpResponse: httpUrlResponse, data: data)
			if let validResponseStatusCodes = request.validResponseStatusCodes, !validResponseStatusCodes.contains(httpUrlResponse.statusCode) {
				let error = (try? JSONDecoder().decode(R.CustomError.self, from: data)) ?? NetworkingError.unknownNetworkingError
				if let requestRetrier, await requestRetrier.retry(urlRequest, httpUrlResponse: httpUrlResponse, for: session, dueTo: error) {
					(data, httpUrlResponse) = try await execute(request)
				} else {
					throw error
				}
			}
		} catch {
			throw error
		}

		return (data, httpUrlResponse)
	}

	func urlRequest<R: HTTPRequest>(_ request: R) async throws -> URLRequest {
		var urlRequest = URLRequest.make(from: request, endpoint: endpoint)
		if let requestAdapter {
			let request = await requestAdapter.adapt(urlRequest, for: session)
			urlRequest = request
		}
		log.debug(urlRequest.curlString)
		return urlRequest
	}

	private func logToConsole(httpRequest: URLRequest, httpResponse: HTTPURLResponse, data: Data) {
		log.debug("Status code: \(httpResponse.statusCode) for \"\(httpRequest.url!.absoluteString)\"")
		if let responseBody = data.prettyJson {
			log.debug(responseBody)
		}
	}
}

protocol RequestAdapter {
	func adapt(_ urlRequest: URLRequest, for session: URLSession) async -> URLRequest
}

protocol RequestRetrier {
	func retry(_ request: URLRequest, httpUrlResponse: HTTPURLResponse, for session: URLSession, dueTo error: Error) async -> Bool
}

extension URLSession {
	
	func perform(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
		if #available(iOS 15.0, *) {
			return try await self.data(for: request) as! (Data, HTTPURLResponse)
		} else {
			return try await self.performBackwardCompatibleRequest(request)
		}
	}
	
	private func performBackwardCompatibleRequest(_ request: URLRequest) async throws -> (Data, HTTPURLResponse) {
		try await withCheckedThrowingContinuation { continuation in
			let task = self.dataTask(with: request) { data, response, error in
				guard let data = data, let response = response else {
					let error = error ?? URLError(.badServerResponse)
					return continuation.resume(throwing: error)
				}
				
				continuation.resume(returning: (data, response as! HTTPURLResponse))
			}
			
			task.resume()
		}
	}
}
