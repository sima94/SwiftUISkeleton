//
//  HTTP.swift
//  Srbija Voz
//
//  Created by Darko Stojkovic on 2.12.21..
//

import Foundation

struct Endpoint {
	let scheme: String
	let urlHost: String
	let port: Int?
}

enum HTTPRequestMethod: String {
	case get = "GET"
	case post = "POST"
	case put = "PUT"
	case delete = "DELETE"
}

struct HTTPRequestHeader {
	let name: String
	let value: String
	
	static var formEncoded: Self {
		contentType("application/x-www-form-urlencoded")
	}
	
	static func contentType(_ value: String) -> HTTPRequestHeader {
		HTTPRequestHeader(name: "Content-Type", value: value)
	}
}

protocol HTTPRequest {
	associatedtype CustomError: Decodable & Error = NetworkingError
	var method: HTTPRequestMethod { get }
	var path: String { get }
	var queryParameters: [URLQueryItem]? { get set }
	var body: Data? { get }
	var headers: [HTTPRequestHeader]? { get set }
	var validResponseStatusCodes: Range<Int>? { get }
}

extension HTTPRequest {
	var validResponseStatusCodes: Range<Int>? { (200..<300) }
}

protocol HTTPFetchRequest: HTTPRequest {
	associatedtype Object: Decodable
	var decoder: JSONDecoder { get set }
}

extension URLRequest {
	static func make<R: HTTPRequest>(from httpRequest: R, endpoint: Endpoint) -> URLRequest {
		var request = URLRequest.make(scheme: endpoint.scheme,
									  host: endpoint.urlHost,
									  port: endpoint.port,
									  path: httpRequest.path,
									  queryItems: httpRequest.queryParameters,
									  method: httpRequest.method.rawValue,
									  body: httpRequest.body)
		for header in httpRequest.headers ?? [] {
			request.addValue(header.value, forHTTPHeaderField: header.name)
		}
		if request.allHTTPHeaderFields?.first(where: { $0.key == "Content-Type" }) == nil {
			request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		}
		return request
	}
	
	private static func make(scheme: String, host: String, port: Int?, path: String, queryItems: [URLQueryItem]? = nil, method: String, body: Data? = nil) -> URLRequest {
		var urlComponents = URLComponents()
		urlComponents.scheme = scheme
		urlComponents.host = host
		urlComponents.port = port
		urlComponents.path = "/\(path)"
		urlComponents.queryItems = queryItems
		var r = URLRequest(url: urlComponents.url!)
		r.httpMethod = method
		r.httpBody = body
		return r
	}

	/**
	 Returns a cURL command representation of this URL request.
	 */
	public var curlString: String {
		guard let url = url else { return "" }
		var baseCommand = #"curl "\#(url.absoluteString)""#

		if httpMethod == "HEAD" {
			baseCommand += " --head"
		}

		var command = [baseCommand]

		if let method = httpMethod, method != "GET" && method != "HEAD" {
			command.append("-X \(method)")
		}

		if let headers = allHTTPHeaderFields {
			for (key, value) in headers where key != "Cookie" {
				command.append("-H '\(key): \(value)'")
			}
		}

		if let data = httpBody, let body = String(data: data, encoding: .utf8) {
			command.append("-d '\(body)'")
		}

		return command.joined(separator: " \\\n\t")
	}
}
