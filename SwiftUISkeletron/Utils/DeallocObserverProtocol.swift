//
//  AnyObject+Extensions.swift
//  SwiftUISkeletron
//
//  Created by Stefan Simic on 27.5.25..
//

import Foundation
import ObjectiveC.runtime

protocol DeallocObserverProtocol: AnyObject {
	func observeDeinit(of object: AnyObject, onDeinit: @escaping () -> Void)
}

extension DeallocObserverProtocol {
	func observeDeinit(of object: AnyObject, onDeinit: @escaping () -> Void) {
		let observer = DeallocObserver(onDeinit: onDeinit)
		objc_setAssociatedObject(object, "[dealloc_observer]", observer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
	}
}

final private class DeallocObserver {
	private let onDeinit: () -> Void

	init(onDeinit: @escaping () -> Void) {
		self.onDeinit = onDeinit
	}

	deinit {
		onDeinit()
	}
}
