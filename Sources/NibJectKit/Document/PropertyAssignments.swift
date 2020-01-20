//
//  PropertyAssignments.swift
//  
//
//  Created by Luke Davis on 1/19/20.
//

import Foundation
import CodeWriter

struct PropertyAssignments {
    var property: RawExpression
    var view: IBUIView
    var isExplicit: Bool = false
    
    init(propertyName: String, view: IBUIView, isExplicit: Bool) {
        self.property = RawExpression(rawValue: propertyName)
        self.view = view
        self.isExplicit = isExplicit
    }
    
    func make() -> [StatementRepresentable] {
        var statements: [StatementRepresentable] = makeAssignments()
        switch view {
        case let stackView as IBUIStackView:
            let assignments = UIStackViewPropertyAssignments(property: property,
                                                             view: stackView,
                                                             isExplicit: isExplicit)
            statements.append(contentsOf: assignments.make())
        default:
            break
        }
        return statements
    }
    
    private func makeAssignments() -> [StatementRepresentable] {
        var statements: [StatementRepresentable] = []
        statements.append(makeTranslatesAutoresizingMaskAssignment())
        return statements
    }
    
    // MARK: - Translates AutoresizingMask
    private func makeTranslatesAutoresizingMaskAssignment() -> StatementRepresentable {
        return makeMemberAssignemnt(member: "translatesAutoresizingMaskIntoConstraints",
                                    value: "\(view.translatesToAutoResizeMask)")
    }
    
    private func makeMemberAssignemnt(member: String, value: String) -> AssignmentOperatorExpression {
        let explicitMember = ExplicitMemberExpression(expression: property, member: RawExpression(rawValue: member))
        return AssignmentOperatorExpression(expression: explicitMember, value: RawExpression(rawValue: value))
    }
    
}

struct UIStackViewPropertyAssignments {
    var property: RawExpression
    var view: IBUIStackView
    var isExplicit: Bool
    
    init(property: RawExpression, view: IBUIStackView, isExplicit: Bool) {
        self.property = property
        self.view = view
        self.isExplicit = isExplicit
    }
    
    func make() -> [StatementRepresentable] {
        var statements: [StatementRepresentable] = []
        if shouldShowAlignment {
            statements.append(makeAlignmentAssignment())
        }
        if shouldShowAxis {
            statements.append(makeAxisAssignment())
        }
        if shouldShowBaselineArrangment {
            statements.append(makeBaselineArrangmentAssignment())
        }
        if shouldShowDistribution {
            statements.append(makeDistributionAssignment())
        }
        if shouldShowSpacing {
            statements.append(makeSpacingAssignment())
        }
        return statements
    }

    // MARK: - Alignemnt
    private var shouldShowAlignment: Bool { isExplicit || !isDefaultAlignmentValue }
    
    private var isDefaultAlignmentValue: Bool { view.alignment == .fill }
    
    private func makeAlignmentAssignment() -> StatementRepresentable {
        var value = "."
        switch view.alignment {
        case .fill: value += "fill"
        case .leading: value += "leading"
        case .center: value += "center"
        case .trailing: value += "trailing"
        }
        return makeMemberAssignemnt(member: "alignment", value: value)
    }
    
    // MARK: - Axis
    private var shouldShowAxis: Bool { isExplicit || !isDefaultAxisValue }
    
    private var isDefaultAxisValue: Bool { view.axis == .horizontal }
    
    private func makeAxisAssignment() -> StatementRepresentable {
        var value = "."
        switch view.axis {
        case .horizontal: value += "horizontal"
        case .vertical: value += "vertical"
        }
        return makeMemberAssignemnt(member: "axis", value: value)
    }
    
    // MARK: - Baseline Arrangment
    private var shouldShowBaselineArrangment: Bool { isExplicit || !isDefaultBaselineArrangmentValue }
    
    private var isDefaultBaselineArrangmentValue: Bool { view.baselineRelative == false }
    
    private func makeBaselineArrangmentAssignment() -> StatementRepresentable {
        var value = "false"
        if view.baselineRelative {
            value = "true"
        }
        return makeMemberAssignemnt(member: "isBaselineRelativeArrangement", value: value)
    }
    
    // MARK: - Distribution
    private var shouldShowDistribution: Bool { isExplicit || !isDefaultDistributionValue }
    
    private var isDefaultDistributionValue: Bool { view.distribution == .fill }
    
    private func makeDistributionAssignment() -> StatementRepresentable {
        var value = "."
        switch view.distribution {
        case .fill: value += "fill"
        case .fillEqually: value += "fillEqually"
        case .fillProportionally: value += "fillProportionally"
        case .equalSpacing: value += "equalSpacing"
        case .equalCentering: value += "equalCentering"
        }
        return makeMemberAssignemnt(member: "distribution", value: value)
    }
    
    // MARK: - Spacing
    private var shouldShowSpacing: Bool { isExplicit || !isDefaultSpacingValue }
    
    private var isDefaultSpacingValue: Bool { view.spacing == 0 }
    
    private func makeSpacingAssignment() -> StatementRepresentable {
        return makeMemberAssignemnt(member: "spacing", value: "\(view.spacing)")
    }
    
    private func makeMemberAssignemnt(member: String, value: String) -> AssignmentOperatorExpression {
        let explicitMember = ExplicitMemberExpression(expression: property, member: RawExpression(rawValue: member))
        return AssignmentOperatorExpression(expression: explicitMember, value: RawExpression(rawValue: value))
    }

}
