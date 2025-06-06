//
//  NetworkingError.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 29.4.25..
//
import Foundation

struct NetworkingError: LocalizedError, Decodable {
	let message: String

	enum CodingKeys: String, CodingKey {
		case message = "message"
	}

	var errorDescription: String? {
		message
	}
}
