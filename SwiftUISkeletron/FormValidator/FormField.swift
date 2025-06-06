//
//  FormField.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 13.5.25..
//

import Foundation

@propertyWrapper
@Observable
class FormField<Value>: Validatable {
	
	var wrappedValue: Value {
		didSet {
			if autoValidate {
				validate()
			}
		}
	}

	var projectedValue: FormField<Value> { self }

	var error: ValidationError?
	var rules: [ValidationRule] = []
	var autoValidate: Bool

	init(wrappedValue: Value, rules: [ValidationRule] = [], autoValidate: Bool = false) {
		self.wrappedValue = wrappedValue
		self.rules = rules
		self.autoValidate = autoValidate
	}

	func addRule(_ rule: ValidationRule) {
		rules.append(rule)
	}

	@discardableResult
	func validate() -> Bool {
		for rule in rules {
			switch rule.isValid(wrappedValue) {
			case .success:
				continue
			case .failure(let err):
				self.error = err
				return false
			}
		}
		self.error = nil
		return true
	}
}
