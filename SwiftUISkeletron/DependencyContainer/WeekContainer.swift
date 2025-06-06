//
//  WeekContainer.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 27.5.25..
//

import Foundation

final class WeekContainer<Value: AnyObject> {

	weak var value: Value?

	init(_ value: Value, onDeinit: (() -> Void)? = nil) {
		self.value = value
		if let onDeinit {
			observeDeinit(of: value, onDeinit: onDeinit)
		}
	}

}

extension WeekContainer: DeallocObserverProtocol {}
