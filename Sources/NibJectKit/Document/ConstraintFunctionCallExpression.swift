//
//  ConstraintFunctionCallExpression.swift
//  
//
//  Created by Luke Davis on 12/30/19.
//

import CodeWriter
import Foundation

struct ViewLayoutSectionMaker {

    var rootView: IBUIView

    func make() throws -> DeclarationRepresentable {
        let graph = IBUIViewGraph(view: rootView)
        return JoinedDeclarationExpression(try makeLayoutSection(for: graph))
    }

    private func makeLayoutSection(for viewGraph: IBUIViewGraph) throws -> [DeclarationRepresentable] {
        var properties: [DeclarationRepresentable] = []
        for view in viewGraph.flattenHierarchy() {
            if view.constraints.isEmpty { continue }
            properties.append(try ViewLayoutMethodMaker(view: view).make())
        }
        return properties
    }

}

private struct ViewLayoutMethodMaker {

    var view: IBUIView

    func make() throws -> DeclarationRepresentable {
        let constraints = try ConstraintFunctionCallSectionMaker(view: view).make()
        let function = FunctionDeclaration { builder in
            builder.accessLevel(.private)
            builder.setIdentifier("layout\(view.propertyName.upperCamelCased)")
            builder.statements(constraints)
            builder.returns("[NSLayoutConstraint]")
        }
        return function
    }

}

private struct ConstraintFunctionCallSectionMaker {

    var view: IBUIView

    func make() throws -> [StatementRepresentable] {
        var statements: [StatementRepresentable] = []
        var constraintNameAssignment: [String: Int] = [:]
        for constraint in view.constraints.sorted(by: { $0.firstAnchor.rawValue < $1.firstAnchor.rawValue }) {
            let maker = ConstraintFunctionCallExpressionMaker(constraint: constraint)
            let statement = try maker.make(using: relativeLookup(for: view))
            let propertyAssignment = ConstantDeclaration { builder in
                builder.setName(makePropertyName(for: constraint, assignedNames: &constraintNameAssignment))
                builder.expression(statement)
            }
            statements.append(propertyAssignment)
        }
        let properties: [String] = constraintNameAssignment.map({
            if $1 > 1 {
                return "\($0)\($1)"
            }
            return $0
        }).sorted(by: { $0 < $1 })
        // swiftlint:disable:next todo
        // TODO: Clean this up. Need to add array expression
        let returnStatement = ReturnExpression(expression:
            RawExpression(rawValue: "[\n    \(properties.joined(separator: ",\n    "))\n]"))
        statements.append(returnStatement)
        return statements
    }

    private func relativeLookup(for view: IBUIView) -> ConstraintFunctionCallExpressionMaker.ViewLocator {
        return { firstID, secondID in
            guard let firstItem = view.findDistantRelative(for: firstID) else {
                throw GeneratedSwiftFileError.missingConstraintItem(missingObjectID: firstID)
            }
            var secondItem: IBUIView? = .none
            if let secondID = secondID {
                secondItem = view.findDistantRelative(for: secondID)
            }
            return (firstItem, secondItem)
        }
    }

    private func makePropertyName(for constraint: IBLayoutConstraint, assignedNames: inout [String: Int]) -> String {
        let name = constraint.firstAnchor
            .generateAnchor()
            .replacingOccurrences(of: "Anchor", with: "")
            .replacingOccurrences(of: ".", with: "")
        if var count = assignedNames[name] {
            count += 1
            assignedNames[name] = count
            return "\(name)\(count)"
        } else {
            assignedNames[name] = 1
            return name
        }
    }
}

struct ConstraintFunctionCallExpressionMaker {
    typealias ViewLocator = (Nib.ObjectID, Nib.ObjectID?) throws -> ((IBUIView, IBUIView?))
    var constraint: IBLayoutConstraint
    init(constraint: IBLayoutConstraint) {
        self.constraint = constraint
    }

    func make(using viewLocator: ViewLocator) rethrows -> ExpressionRepresentable {
        let locatedViews = try viewLocator(constraint.firstItemID, constraint.secondItemID)
        let firstExpression = makeItemMemberExpression(for: locatedViews.0, and: constraint.firstAnchor)
        let funcCallEpression = FunctionCallExpression { builder in
            builder.functionName("constraint")
            guard let secondView = locatedViews.1 else {
                builder.addArgument(name: "\(constraint.relation.generateRelation())Constant",
                                    value: "\(constraint.constant)")
                return
            }
            let secondExpression = makeItemMemberExpression(for: secondView, and: constraint.secondAnchor)
            builder.addArgument(name: constraint.relation.generateRelation(), value: secondExpression.outputText)
            if constraint.firstAnchor.isLayoutDimension {
                builder.addArgument(name: "multiplier", value: "\(constraint.multiplier)")
            }
            if constraint.constant != 0.0 {
                builder.addArgument(name: "constant", value: "\(constraint.constant)")
            }
        }
        return ExplicitMemberExpression(expression: firstExpression, member: funcCallEpression)
    }

    private func makeItemMemberExpression(for item: IBUIView,
                                          and anchor: IBLayoutConstraint.Anchor) -> ExpressionRepresentable {
        let memberExpression = RawExpression(rawValue: anchor.generateAnchor())
        guard let expression = makeSafeAreaLayoutMemberExpression(for: item) else {
            return memberExpression
        }
        return ExplicitMemberExpression(expression: expression, member: memberExpression)
    }

    private func makeSafeAreaLayoutMemberExpression(for item: IBUIView) -> ExpressionRepresentable? {
        let safeAreaExpression = RawExpression(rawValue: "safeAreaLayoutGuide")
        guard item.shouldUsePropertyName else {
            if item.hasSafeArea { return safeAreaExpression } else { return .none }
        }
        let propertyNameExpression = RawExpression(rawValue: item.propertyName)
        guard item.hasSafeArea else { return propertyNameExpression }
        return ExplicitMemberExpression(expression: propertyNameExpression, member: safeAreaExpression)
    }

}
