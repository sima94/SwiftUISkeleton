//
//  StringLengthRule.swift
//  Srbija Voz
//
//  Created by Stefan Simic on 2.2.22..
//

import Foundation

struct StringLengthRule: ValidationRule {
	typealias Value = String
	
	let min: Int
	let max: Int
	let trimWhiteSpace: Bool
	let ignoreCharacterSet: CharacterSet?
	let error: ValidationError
	
	init(
		min: Int = 0,
		max: Int = Int.max,
		trimWhiteSpace: Bool = true,
		ignoreCharactersIn characterSet: CharacterSet? = nil,
		error: ValidationError
	) {
		
		self.min = min
		self.max = max
		self.trimWhiteSpace = trimWhiteSpace
		self.ignoreCharacterSet = characterSet
		self.error = error
	}
	
	func isValid(_ value: Any) -> Result<Void, ValidationError> {
		guard let value = value as? String else { return .failure(error) }
		var valueToBeValidated = value
		
		if let characterSet = ignoreCharacterSet {
			let passed = valueToBeValidated.unicodeScalars.filter { !characterSet.contains($0) }
			valueToBeValidated = String(String.UnicodeScalarView(passed))
		}
		if trimWhiteSpace {
			valueToBeValidated = valueToBeValidated.trimmingCharacters(
				in: .whitespacesAndNewlines
			)
		}
		
		let isValid = valueToBeValidated.count >= min && valueToBeValidated.count <= max
		
		return isValid ? .success(()) : .failure(error)
	}
	
}

extension StringLengthRule {
	
	static func required(
		trimWhiteSpace: Bool = true,
		ignoreCharactersIn characterSet: CharacterSet? = nil,
		errorMessage: String = "ValidationError.Required"
	) -> StringLengthRule {
		
		return StringLengthRule(
			min: 1,
			trimWhiteSpace: trimWhiteSpace,
			ignoreCharactersIn: characterSet,
			error: ValidationError(message: errorMessage)
		)
	}
	
	static func password(
		trimWhiteSpace: Bool = true,
		ignoreCharactersIn characterSet: CharacterSet? = nil,
		errorMessage: String = "ValidationError.Password.TooShort"
	) -> StringLengthRule {
		
		return StringLengthRule(
			min:8,
			trimWhiteSpace: trimWhiteSpace,
			ignoreCharactersIn: characterSet,
			error: ValidationError(message: errorMessage)
		)
	}
	
}
