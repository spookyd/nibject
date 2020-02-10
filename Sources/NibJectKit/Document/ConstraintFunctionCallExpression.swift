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
            let propertyName = makePropertyName(for: constraint, assignedNames: &constraintNameAssignment)
            let propertyAssignment = ConstantDeclaration { builder in
                builder.setName(propertyName)
                builder.expression(statement)
            }
            statements.append(propertyAssignment)
            if !isDefaultPriority(constraint.priority) {
                let prop = RawExpression(rawValue: propertyName)
                let value = makePriorityExpression(constraint.priority)
                let propertyExpression = ExplicitMemberExpression(expression: prop,
                                                                  member: RawExpression(rawValue: "priority"))
                let assignmentExpression = AssignmentOperatorExpression(expression: propertyExpression, value: value)
                statements.append(assignmentExpression)
            }
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
        var name: String
        if let customName = constraint.customName {
            name = customName.lowerCamelCased
        } else {
            name = constraint.firstAnchor
                .generateAnchor()
                .replacingOccurrences(of: "Anchor", with: "")
                .replacingOccurrences(of: ".", with: "")
        }
        if var count = assignedNames[name] {
            count += 1
            assignedNames[name] = count
            return "\(name)\(count)"
        } else {
            assignedNames[name] = 1
            return name
        }
    }

    private func isDefaultPriority(_ value: Int) -> Bool { value == 1000 }

    private func makePriorityExpression(_ value: Int) -> ExpressionRepresentable {
        let layoutExpression = RawExpression(rawValue: "UILayoutPriority")
        switch value {
        case 1000:
            return ExplicitMemberExpression(expression: layoutExpression, member: RawExpression(rawValue: "required"))
        case 750:
            return ExplicitMemberExpression(expression: layoutExpression,
                                            member: RawExpression(rawValue: "defaultHigh"))
        case 250:
            return ExplicitMemberExpression(expression: layoutExpression,
                                            member: RawExpression(rawValue: "defaultLow"))
        default:
            return InitializerExpression { builder in
                builder.initializingExpression(layoutExpression)
                builder.addArgument(name: "rawValue", value: "\(value)")
            }
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

struct ContentCompressionHuggingStatements {
    let property: RawExpression
    let view: IBUIView
    var isExplicit: Bool
    init(propertyName: String, view: IBUIView, isExplicit: Bool) {
        self.property = RawExpression(rawValue: propertyName)
        self.view = view
        self.isExplicit = isExplicit
    }
    
    func make() -> [StatementRepresentable] {
        var statements: [StatementRepresentable] = []
        if shouldShowHorizontalContentCompressionResistancePriority {
            let value = view.horizontalContentCompressionResistancePriority
            let statement = makeSetContentCompressionResistance(.horizontal, value: value)
            statements.append(statement)
        }
        if shouldShowHorizontalContentHuggingPriority {
            let value = view.horizontalContentHuggingPriority
            let statement = makeSetContentHugging(.horizontal, value: value)
            statements.append(statement)
        }
        if shouldShowVerticalContentCompressionResistancePriority {
            let value = view.horizontalContentCompressionResistancePriority
            let statement = makeSetContentCompressionResistance(.vertical, value: value)
            statements.append(statement)
        }
        if shouldShowVerticalContentHuggingPriority {
            let value = view.horizontalContentHuggingPriority
            let statement = makeSetContentHugging(.vertical, value: value)
            statements.append(statement)
        }
        return statements
    }
    
    var shouldShowHorizontalContentCompressionResistancePriority: Bool {
        isExplicit || !isDefaultHorizontalContentCompressionResistancePriority
    }
    
    var isDefaultHorizontalContentCompressionResistancePriority: Bool {
        view.horizontalContentCompressionResistancePriority == view.defaultHorizontalContentCompressionResistancePriority
    }
    
    var shouldShowHorizontalContentHuggingPriority: Bool {
        isExplicit || !isDefaultHorizontalContentHuggingPriority
    }
    
    var isDefaultHorizontalContentHuggingPriority: Bool {
        view.horizontalContentHuggingPriority == view.defaultHorizontalContentHuggingPriority
    }
    
    var shouldShowVerticalContentCompressionResistancePriority: Bool {
        isExplicit || !isDefaultVerticalContentCompressionResistancePriority
    }
    
    var isDefaultVerticalContentCompressionResistancePriority: Bool {
        view.verticalContentCompressionResistancePriority == view.defaultVerticalContentCompressionResistancePriority
    }
    
    var shouldShowVerticalContentHuggingPriority: Bool {
        isExplicit || !isDefaultVerticalContentHuggingPriority
    }
    
    var isDefaultVerticalContentHuggingPriority: Bool {
        view.verticalContentHuggingPriority == view.defaultVerticalContentHuggingPriority
    }
    
    private enum Direction {
        case horizontal
        case vertical
        var outputText: String {
            switch self {
            case .horizontal: return ".horizontal"
            case .vertical: return ".vertical"
            }
        }
    }
    
    private func makeSetContentCompressionResistance(_ direction: Direction, value: Float) -> ExpressionRepresentable {
        // view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        let priority = makeLayoutPriority(value)
        let expression = FunctionCallExpression.init { builder in
            builder.functionName("setContentCompressionResistancePriority")
            builder.addArgument(value: priority.outputText)
            builder.addArgument(name: "for", value: direction.outputText)
        }
        return ExplicitMemberExpression(expression: property, member: expression)
    }
    
    private func makeSetContentHugging(_ direction: Direction, value: Float) -> ExpressionRepresentable {
        // view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        let priority = makeLayoutPriority(value)
        let expression = FunctionCallExpression.init { builder in
            builder.functionName("setContentHuggingPriority")
            builder.addArgument(value: priority.outputText)
            builder.addArgument(name: "for", value: direction.outputText)
        }
        return ExplicitMemberExpression(expression: property, member: expression)
    }
    
    private func makeLayoutPriority(_ value: Float) -> ExpressionRepresentable {
        let expression = RawExpression(rawValue: "UILayoutPriority")
        switch value {
        case 1000:
            let member = RawExpression(rawValue: "required")
            return ExplicitMemberExpression(expression: expression, member: member)
        case 750:
            let member = RawExpression(rawValue: "defaultHigh")
            return ExplicitMemberExpression(expression: expression, member: member)
        case 250:
            let member = RawExpression(rawValue: "defaultLow")
            return ExplicitMemberExpression(expression: expression, member: member)
        default:
            return InitializerExpression { builder in
                builder.initializingExpression(expression)
                builder.addArgument(name: "rawValue", value: "\(value)")
            }
        }
    }
    
    private func makeMemberAssignemnt(member: String, value: String) -> AssignmentOperatorExpression {
        let explicitMember = ExplicitMemberExpression(expression: property, member: RawExpression(rawValue: member))
        return AssignmentOperatorExpression(expression: explicitMember, value: RawExpression(rawValue: value))
    }
}
