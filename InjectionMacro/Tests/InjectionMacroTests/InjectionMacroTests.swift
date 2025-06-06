import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(InjectionMacroMacros)
import InjectionMacroMacros

let testMacros: [String: Macro.Type] = [
	"Inject": InjectMacro.self,
]
#endif

final class InjectMacroTests: XCTestCase {

	func testInjectMacro() {
		assertMacroExpansion(
			"@Inject(.singleton) var manager: LoginManager",
			expandedSource: """
			@ObservationIgnored
			var manager: LoginManager = DependencyContainer.shared.resolve(DependencyType.singleton, LoginManager.self)!
			""",
			macros: testMacros
		)
	}
}
