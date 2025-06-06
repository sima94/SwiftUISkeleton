//
//  StringRegexRule.swift
//  Srbija Voz
//
//  Created by Stefan Simic on 2.2.22..
//

import Foundation

struct StringRegexRule: ValidationRule {
	let regex: String
	let trimWhiteSpace: Bool
	let error: ValidationError
	
	init(regex: String, trimWhiteSpace: Bool = true, error: ValidationError) {
		self.regex = regex
		self.trimWhiteSpace = trimWhiteSpace
		self.error = error
	}
	
	func isValid(_ value: Any) -> Result<Void, ValidationError> {
		guard let value = value as? String else { return .failure(error) }
		var valueToBeValidated = value
		
		if trimWhiteSpace {
			valueToBeValidated = valueToBeValidated.trimmingCharacters(in: .whitespacesAndNewlines)
		}
		
		let isValid = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: valueToBeValidated)
		
		return isValid ? .success(()) : .failure(error)
	}
	
}

extension StringRegexRule {
	
	private enum Constants {
		static let email = "^[a-zA-Z0-9\\+\\.\\_\\%\\-\\+]{1,256}\\@[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}(\\.[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25})+$"
	}
	
	static func email(errorMessage: String = "ValidationError.Email") -> StringRegexRule {
		StringRegexRule(
			regex: Constants.email,
			error: ValidationError(message: errorMessage))
	}
}
