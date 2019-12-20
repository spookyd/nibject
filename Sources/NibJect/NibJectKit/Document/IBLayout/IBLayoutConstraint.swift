//
//  IBLayoutConstraint.swift
//  
//
//  Created by Luke Davis on 12/1/19.
//

import Foundation
import CodeWriter

public struct IBLayoutConstraint {

    public enum Relation: Int {
        case lessThanOrEqualTo = -1
        case equalTo = 0
        case greaterThanOrEqualTo = 1

        func generateRelation() -> String {
            switch self {
            case .lessThanOrEqualTo: return "lessThanOrEqualTo"
            case .equalTo: return "equalTo"
            case .greaterThanOrEqualTo: return "greaterThanOrEqualTo"
            }
        }

    }


    // Anchor types
    // 0 = none
    // 1 = Left Anchor
    // 2 = Right Anchor
    // 3 = Top Anchor
    // 4 = Bottom Anchor
    // 5 = Leading Anchor
    // 6 = Trailing Anchor
    // 7 = Width Anchor
    // 8 = Height Anchor
    // 9 = Center X Anchor
    // 10 = Center Y Anchor
    // 11 = Last Baseline Anchor
    // 12 = First Baseline Anchor
    // 13 = Left Anchor of Layout Margin Guide
    // 14 = Right Anchor of Layout Margin Guide
    // 15 = Top Anchor of Layout Margin Guide
    // 16 = Bottom Anchor of Layout Margin Guide
    // 17 = Leading Anchor of Layout Margin Guide
    // 18 = Trailing Anchor of Layout Margin Guide
    // 19 = Center X Anchor of Layout Margin Guide
    // 20 = Center Y Anchor of Layout Margin Guide
    public enum Anchor: Int {
        case none = 0
        case left
        case right
        case top
        case bottom
        case leading
        case trailing
        case width
        case height
        case centerX
        case centerY
        case lastBaseline
        case firstBaseline
        case leftMargin
        case rightMargin
        case topMargin
        case bottomMargin
        case leadingMargin
        case trailingMargin
        case centerXMargin
        case centerYMargin

        var isToMargin: Bool { self.rawValue >= Anchor.leftMargin.rawValue }

        var isLayoutDimension: Bool { self == .width || self == .height }

        func generateAnchor() -> String {
            let anchorString: String
            switch self {
            case .left, .leftMargin: anchorString = "leftAnchor"
            case .right, .rightMargin: anchorString = "rightAnchor"
            case .top, .topMargin: anchorString = "topAnchor"
            case .bottom, .bottomMargin: anchorString = "bottomAnchor"
            case .leading, .leadingMargin: anchorString = "leadingAnchor"
            case .trailing, .trailingMargin: anchorString = "trailingAnchor"
            case .width: return "widthAnchor"
            case .height: return "heightAnchor"
            case .centerX, .centerXMargin: anchorString = "centerXAnchor"
            case .centerY, .centerYMargin: anchorString = "centerYAnchor"
            case .lastBaseline: return "lastBaselineAnchor"
            case .firstBaseline: return "firstBaselineAnchor"
            case .none: return ""
            }
            return prependMarginLayout(anchorString)
        }

        private func prependMarginLayout(_ anchorString: String) -> String {
            guard isToMargin else { return anchorString }
            return "layoutMarginsGuide.\(anchorString)"
        }

    }

    public var objectID: Nib.ObjectID
    public var firstItemID: Nib.ObjectID
    public var firstAnchor: Anchor
    public var secondItemID: Nib.ObjectID?
    public var secondAnchor: Anchor
    public var relation: Relation
    public var constant: Float
    public var priority: Int
    public var multiplier: Float

    public typealias ViewLocator = (Nib.ObjectID, Nib.ObjectID?) throws -> ((IBUIView, IBUIView?))
    public func makeLayoutConstraintFunctionCall(_ viewLocator: ViewLocator) rethrows -> FunctionCall {
        let locatedViews = try viewLocator(firstItemID, secondItemID)
        let firstItem = locatedViews.0
        var callee = ""
        if firstItem.shouldUsePropertyName {
            callee += "\(firstItem.propertyName)"
        }
        if !callee.isEmpty {
            callee += "."
        }
        if firstItem.hasSafeArea {
            callee += "safeAreaLayoutGuide."
        }
        callee += "\(firstAnchor.generateAnchor())."
        var builder: FunctionCallComponentParameterizable = FunctionCallBuilder(named: "\(callee)constraint")
        guard let secondItem = locatedViews.1 else {
            return builder.parameter(label: "\(relation.generateRelation())Constant", name: "\(constant)").complete()
        }
        var secondProperty = ""
        if secondItem.shouldUsePropertyName {
            secondProperty += "\(secondItem.propertyName)"
        }
        if !secondProperty.isEmpty {
            secondProperty += "."
        }
        if secondItem.hasSafeArea {
            secondProperty += "safeAreaLayoutGuide."
        }
        builder = builder.parameter(label: relation.generateRelation(),
                                    name: "\(secondProperty)\(secondAnchor.generateAnchor())")
        if firstAnchor.isLayoutDimension {
            builder = builder.parameter(label: "multiplier", name: "\(multiplier)")
        }

        if constant != 0.0 {
            builder = builder.parameter(label: "constant", name: "\(constant)")
        }
        return builder.complete()
    }
    
    public static func make(for object: NibObject) -> IBLayoutConstraint {
        return NibConstraintParser(object: object).parse()
    }

}

struct NibConstraintParser {
    var object: NibObject

    func parse() -> IBLayoutConstraint {
        let objectID = object.objectID
        let firstItem = findFirstItem()
        let firstAnchor = findFirstAnchor()
        let secondItem = findSecondItem()
        let secondAnchor = findSecondAnchor()
        let relation = findRelation()
        let constant = findConstant()
        let priority = findPriority()
        let multiplier = findMultiplier()

        return IBLayoutConstraint(objectID: objectID,
                                  firstItemID: firstItem,
                                  firstAnchor: firstAnchor,
                                  secondItemID: secondItem,
                                  secondAnchor: secondAnchor,
                                  relation: relation,
                                  constant: constant,
                                  priority: priority,
                                  multiplier: multiplier)
    }

    private func findFirstItem() -> Nib.ObjectID {
        guard let firstItem = object.content["firstItem"] as? [AnyHashable: Any],
            let firstItemID = firstItem["ObjectID"] as? Nib.ObjectID else {
            fatalError("Could not find first item in \(object)")
        }
        return firstItemID
    }

    private func findFirstAnchor() -> IBLayoutConstraint.Anchor {
        guard let relationRawValue = object.content["firstAttribute"] as? Int else {
            fatalError("Could not find firstAttribute in \(object)")
        }
        guard let anchor = IBLayoutConstraint.Anchor(rawValue: relationRawValue) else {
            fatalError("Invalid anchor type \(relationRawValue)")
        }
        return anchor
    }

    private func findSecondItem() -> Nib.ObjectID? {
        guard let secondItem = object.content["secondItem"] as? [AnyHashable: Any],
            let secondItemID = secondItem["ObjectID"] as? Nib.ObjectID else {
                return .none
        }
        return secondItemID
    }

    private func findSecondAnchor() -> IBLayoutConstraint.Anchor {
        guard let anchorRawValue = object.content["secondAttribute"] as? Int else {
            return .none
        }
        guard let anchor = IBLayoutConstraint.Anchor(rawValue: anchorRawValue) else {
            return .none
        }
        return anchor
    }

    private func findRelation() -> IBLayoutConstraint.Relation {
        guard let relationRawValue = object.content["relation"] as? Int else {
            fatalError("Could not find relation in \(object)")
        }
        guard let relation = IBLayoutConstraint.Relation(rawValue: relationRawValue) else {
            fatalError("Invalid relation type \(relationRawValue)")
        }
        return relation
    }

    private func findConstant() -> Float {
        guard let constant = object.content["constant"] as? [AnyHashable: Any],
            let realConstant = constant["value"] as? Float else {
            return 0.0
        }
        return realConstant
    }

    private func findPriority() -> Int {
        guard let priority = object.content["priority"] as? Int else {
            return 0
        }
        return priority
    }

    private func findMultiplier() -> Float {
        guard let value = object.content["multiplier"] as? Float else {
            return 1
        }
        return value
    }
    

}
