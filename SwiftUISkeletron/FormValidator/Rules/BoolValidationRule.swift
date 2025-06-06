//
//  BoolValidationRule.swift
//  Srbija Voz
//
//  Created by Stefan Simic on 6.2.22..
//

import Foundation

struct BoolValidationRule: ValidationRule {

	let requiredValue: Bool
	let error: ValidationError

	init(requiredValue: Bool, error: ValidationError = .init(message: nil)) {
		self.requiredValue = requiredValue
		self.error = error
	}

	func isValid(_ value: Any) -> Result<Void, ValidationError> {
		guard let value = value as? Bool else { return .failure(error) }
		return requiredValue == value ? .success(()) : .failure(error)
	}
}
