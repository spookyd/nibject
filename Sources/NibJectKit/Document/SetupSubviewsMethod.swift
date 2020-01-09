//
//  SetupSubviewsMethod.swift
//  
//
//  Created by Luke Davis on 12/14/19.
//

import CodeWriter
import Foundation

struct SetupSubviewsMethod {

    private let constraintsExpression = RawExpression(rawValue: "constraints")
    let rootView: IBUIView

    func make() -> DeclarationRepresentable {
        return FunctionDeclaration { builder in
            builder.accessLevel(.private)
            builder.setIdentifier("setupSubviews")
            builder.statements(makeFunctionBody())
        }
    }

    private func makeFunctionBody() -> [StatementRepresentable] {
        var body: [StatementRepresentable] = []
        body.append(contentsOf: makeAddSubviewCalls())
        // swiftlint:disable:next todo
        // FIXME: Fix shortcut
        body.append(RawExpression(rawValue: "var \(constraintsExpression.outputText): [NSLayoutConstraint] = []"))
        body.append(contentsOf: makeLayoutSubviewCalls())
        let activateFunction = FunctionCallExpression { builder in
            builder.functionName("activate")
            builder.addArgument(value: constraintsExpression.outputText)
        }
        body.append(ExplicitMemberExpression(expression: RawExpression(rawValue: "NSLayoutConstraint"),
                                             member: activateFunction))
        return body
    }

    private func makeAddSubviewCalls() -> [StatementRepresentable] {
        return makeAddSubviewCall(for: rootView)
    }

    private func makeAddSubviewCall(for view: IBUIView) -> [StatementRepresentable] {
        var calls: [StatementRepresentable] = []
        for child in view.subviews {
            calls.append(child.makeAddSubviewCall())
            if child.subviews.isEmpty { continue }
            calls.append(contentsOf: makeAddSubviewCall(for: child))
        }
        return calls
    }

    private func makeLayoutSubviewCalls() -> [StatementRepresentable] {
        return makeLayoutSubviewCall(for: rootView)
    }

    private func makeLayoutSubviewCall(for view: IBUIView) -> [StatementRepresentable] {
        var calls: [StatementRepresentable] = []
        for child in view.subviews {
            if child.constraints.isEmpty { continue }
            let layoutExpression = child.makeLayoutMethodCall()
            let constraintAppendCall = FunctionCallExpression { builder in
                builder.functionName("append")
                builder.addArgument(name: "contentsOf", value: layoutExpression.outputText)
            }
            calls.append(ExplicitMemberExpression(expression: constraintsExpression, member: constraintAppendCall))
            if child.subviews.isEmpty { continue }
            calls.append(contentsOf: makeLayoutSubviewCall(for: child))
        }
        return calls
    }

}

private extension IBUIView {
    func makeAddSubviewCall() -> ExpressionRepresentable {
        guard let parent = self.parent else {
            return RawExpression(rawValue: "")
        }
        let functionCall = FunctionCallExpression { builder in
            builder.functionName(parent.addSubviewMethodName())
            builder.addArgument(value: propertyName)
        }
        if parent.isTopLevelView { return functionCall }
        return ExplicitMemberExpression(expression: RawExpression(rawValue: parent.propertyName),
                                        member: functionCall)
    }

    func makeLayoutMethodCall() -> ExpressionRepresentable {
        return FunctionCallExpression { builder in
            builder.functionName("layout\(propertyName.upperCamelCased)")
        }
    }
}
