//
//  IBLayoutConstraint.swift
//  
//
//  Created by Luke Davis on 12/1/19.
//

import Foundation

/**

 From IB this is a "Leading alignment constraint"

 <key>T1R-wf-XOL</key>
 <dict>
     <key>class</key>
     <string>IBLayoutConstraint</string>
     <key>constant</key>
     <dict>
         <key>value</key>
         <real>20</real>
     </dict>
     <key>contentType</key> // Constraint definition?
     <integer>2</integer>
    // Definition types
    // 0 =
    // 1 = Y Axis Constraint
    // 2 = X Axis Constraint
    // 3 = Spacing Constraint // What is the difference?
    // 4 = Dimension Constraint
     <key>firstAttribute</key> // Represents the anchor
     <integer>5</integer>
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
     <key>firstItem</key>
     <dict>
         <key>Class</key>
         <string>UIStackView</string>
         <key>ObjectID</key>
         <string>RbM-Wu-fWn</string>
     </dict>
     <key>ibExternalIdentityShowNotesWithSelection</key>
     <integer>0</integer>
     <key>multiplier</key>
     <string>1</string>
     <key>placeholder</key> // Should ignore placeholder of value 1
     <integer>0</integer>
     <key>priority</key> // Need to set this priority
     <real>1000</real>
     <key>relation</key> // This is equal, greater than, less than
     <integer>0</integer>
    // 0 = Equals,
    // -1 = Less than or equal,
    // 1 = Greater than or equal
     <key>secondAttribute</key> // See `firstAttribute`
     <integer>5</integer>
     <key>secondItem</key>
     <dict>
         <key>Class</key>
         <string>UILayoutGuide</string>
         <key>ObjectID</key>
         <string>vUN-kp-3ea</string>
     </dict>
 </dict>
 */

/**
From IB this is a "Top alignment constraint"
 <key>HWs-dL-nmK</key>
 <dict>
     <key>class</key>
     <string>IBLayoutConstraint</string>
     <key>constant</key>
     <dict>
         <key>value</key>
         <real>94</real>
     </dict>
     <key>contentType</key>
     <integer>2</integer>
     <key>firstAttribute</key>
     <integer>3</integer>
     <key>firstItem</key>
     <dict>
         <key>Class</key>
         <string>UIStackView</string>
         <key>ObjectID</key>
         <string>RbM-Wu-fWn</string>
     </dict>
     <key>ibExternalIdentityShowNotesWithSelection</key>
     <integer>0</integer>
     <key>multiplier</key>
     <string>1</string>
     <key>placeholder</key>
     <integer>0</integer>
     <key>priority</key>
     <real>1000</real>
     <key>relation</key>
     <integer>0</integer>
     <key>secondAttribute</key>
     <integer>3</integer>
     <key>secondItem</key>
     <dict>
         <key>Class</key>
         <string>UILayoutGuide</string>
         <key>ObjectID</key>
         <string>vUN-kp-3ea</string>
     </dict>
 </dict>
 */

//public typealias IBUIView = String
//
//public struct IBLayoutConstraint {
//
//    public enum Relation {
//        case lessThanOrEqualTo
//        case equalTo
//        case greaterThanOrEqualTo
//
//        public init?(_ rawValue: Int) {
//            switch rawValue {
//            case -1: self = .lessThanOrEqualTo
//            case 0: self = .equalTo
//            case 1: self = .greaterThanOrEqualTo
//            default:
//                break
//            }
//            return nil
//        }
//
//        func generateRelation() -> String {
//            switch self {
//            case .lessThanOrEqualTo: return "lessThanOrEqualTo"
//            case .equalTo: return "equalTo"
//            case .greaterThanOrEqualTo: return "greaterThanOrEqualTo"
//            }
//        }
//
//    }
//
//
//    // Anchor types
//    // 0 = none
//    // 1 = Left Anchor
//    // 2 = Right Anchor
//    // 3 = Top Anchor
//    // 4 = Bottom Anchor
//    // 5 = Leading Anchor
//    // 6 = Trailing Anchor
//    // 7 = Width Anchor
//    // 8 = Height Anchor
//    // 9 = Center X Anchor
//    // 10 = Center Y Anchor
//    // 11 = Last Baseline Anchor
//    // 12 = First Baseline Anchor
//    // 13 = Left Anchor of Layout Margin Guide
//    // 14 = Right Anchor of Layout Margin Guide
//    // 15 = Top Anchor of Layout Margin Guide
//    // 16 = Bottom Anchor of Layout Margin Guide
//    // 17 = Leading Anchor of Layout Margin Guide
//    // 18 = Trailing Anchor of Layout Margin Guide
//    // 19 = Center X Anchor of Layout Margin Guide
//    // 20 = Center Y Anchor of Layout Margin Guide
//    public enum Anchor: Int {
//        case none = 0
//        case left
//        case right
//        case top
//        case bottom
//        case leading
//        case trailing
//        case width
//        case height
//        case centerX
//        case centerY
//        case lastBaseline
//        case firstBaseline
//        case leftMargin
//        case rightMargin
//        case topMargin
//        case bottomMargin
//        case leadingMargin
//        case trailingMargin
//        case centerXMargin
//        case centerYMargin
//
//        var isToMargin: Bool { self.rawValue >= 13 }
//
//        var isLayoutDimension: Bool { self == .width || self == .height }
//
//        func generateAnchor() -> String {
//            let anchorString: String
//            switch self {
//            case .left, .leftMargin: anchorString = "leftAnchor"
//            case .right, .rightMargin: anchorString = "rightAnchor"
//            case .top, .topMargin: anchorString = "topAnchor"
//            case .bottom, .bottomMargin: anchorString = "bottomAnchor"
//            case .leading, .leadingMargin: anchorString = "leadingAnchor"
//            case .trailing, .trailingMargin: anchorString = "trailingAnchor"
//            case .width: return "widthAnchor"
//            case .height: return "heightAnchor"
//            case .centerX, .centerXMargin: anchorString = "centerXAnchor"
//            case .centerY, .centerYMargin: anchorString = "centerYAnchor"
//            case .lastBaseline: return "lastBaselineAnchor"
//            case .firstBaseline: return "firstBaselineAnchor"
//            case .none: return ""
//            }
//            return prependMarginLayout(anchorString)
//        }
//
//        private func prependMarginLayout(_ anchorString: String) -> String {
//            guard isToMargin else { return anchorString }
//            return "layoutMarginsGuide.\(anchorString)"
//        }
//
//    }
//
//    public var firstItem: IBUIView
//    public var firstAnchor: Anchor
//    public var secondItem: IBUIView?
//    public var secondAnchor: Anchor
//    public var relation: Relation
//    public var constant: Float
//    public var priority: Int
//    public var multiplier: Float
//
//
//    public func generateConstraint() -> String {
//        // Location Anchors
//        // constraint(equalTo anchor: NSLayoutAnchor<AnchorType>, constant c: CGFloat)
//        // Dimension Anchors
//        // constraint(lessThanOrEqualTo anchor: NSLayoutDimension, multiplier m: CGFloat, constant c: CGFloat)
//        var constraint = "\(firstItem).\(firstAnchor.generateAnchor()).constraint(\(relation.generateRelation())"
//        guard let secondItem = secondItem else {
//            constraint += "Constant: \(constant))"
//            return constraint
//        }
//
//        constraint += ": \(secondItem).\(secondAnchor.generateAnchor())"
//
//        if firstAnchor.isLayoutDimension {
//            constraint += ", multiplier: \(multiplier)"
//        }
//
//        if constant != 0.0 {
//            constraint += ", constant: \(constant)"
//        }
//
//        constraint += ")"
//
//        return constraint
//    }
//
//}

public struct IBLayoutConstraint: CustomStringConvertible {
    
    public var description: String {
        """
        """
    }
}

