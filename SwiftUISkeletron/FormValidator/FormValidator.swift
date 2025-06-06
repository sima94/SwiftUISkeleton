//
//  FormValidator.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 8.5.25..
//

import Foundation

@Observable
class FormValidator {

	var isValid: Bool = true

	private var fields: [any Validatable] = []

	func register(_ field: any Validatable) {
		fields.append(field)
	}

	func validate() -> Bool {
		var isValid = true
		fields.forEach {
			if !$0.validate() {
				isValid = false
			}
		}
		self.isValid = isValid
		return isValid
	}
}

protocol Validatable {
	func validate() -> Bool
}
