//
//  ValidationRule.swift
//  Srbija Voz
//
//  Created by Stefan Simic on 2.2.22..
//

import Foundation
import UIKit

protocol ValidationRule {
	func isValid(_ value: Any) -> Result<Void, ValidationError>
}
