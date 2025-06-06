//
//  Plugin.swift
//  InjectionMacro
//
//  Created by Stefan Simic on 19.5.25..
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct InjectionPlugin: CompilerPlugin {
	let providingMacros: [Macro.Type] = [
		InjectMacro.self
	]
}
