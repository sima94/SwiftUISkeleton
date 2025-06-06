import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct InjectMacro: PeerMacro {
	public static func expansion(
		of node: AttributeSyntax,
		providingPeersOf declaration: some DeclSyntaxProtocol,
		in context: some MacroExpansionContext
	) throws -> [DeclSyntax] {
		guard let varDecl = declaration.as(VariableDeclSyntax.self),
			  let binding = varDecl.bindings.first,
			  let identifier = binding.pattern.as(IdentifierPatternSyntax.self),
			  let typeAnnotation = binding.typeAnnotation else {
			return []
		}

		let varName = identifier.identifier.text
		let typeName = typeAnnotation.type.description.trimmingCharacters(in: .whitespacesAndNewlines)

		// Extract argument (e.g. `.singleton`)
		var depType = "DependencyType.new"
		if let argumentList = node.arguments?.as(LabeledExprListSyntax.self),
		   let firstArg = argumentList.first?.expression {
			let arg = firstArg.description
			depType = arg.hasPrefix(".") ? "DependencyType\(arg)" : arg
		}

		let source = """
		@ObservationIgnored
		var \(varName): \(typeName) = DependencyContainer.shared.resolve(\(depType), \(typeName).self)!
		"""

		return [DeclSyntax(stringLiteral: source)]
	}
}
