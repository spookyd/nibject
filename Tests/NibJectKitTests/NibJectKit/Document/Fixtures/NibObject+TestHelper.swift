//
//  NibObject+TestHelper.swift
//  
//
//  Created by Luke Davis on 12/17/19.
//

import Foundation
@testable import NibJectKit

extension NibObject {
    
    static func makeView(_ objectID: Nib.ObjectID = UUID().uuidString) -> NibObject {
        return NibObject(objectID: objectID, classType: .view, rawClassValue: "UIView", content: [:])
    }
    
    static func makeConstraint(_ objectID: Nib.ObjectID = UUID().uuidString,
                               firstItem: String,
                               secondItem: String?,
                               firstAttribute: IBLayoutConstraint.Anchor = IBLayoutConstraint.Anchor(rawValue: Int.random(in: 1...20))!,
                               secondAttribute: IBLayoutConstraint.Anchor = IBLayoutConstraint.Anchor(rawValue: Int.random(in: 1...20))!,
                               relation: IBLayoutConstraint.Relation = IBLayoutConstraint.Relation(rawValue: Int.random(in: -1...1))!,
                               constant: Float = Float.random(in: 0...100),
                               multiplier: Float = 1.0) -> NibObject {
        var content: [AnyHashable: Any] = [
            "firstItem": ["ObjectID": firstItem],
            "firstAttribute": firstAttribute.rawValue,
            "secondAttribute": secondAttribute.rawValue,
            "relation": relation.rawValue,
            "constant": ["value": constant],
            "priority": 100,
            "multiplier": multiplier
        ]
        if let secondItem = secondItem {
            content["secondItem"] = ["ObjectID": secondItem]
        }
        return NibObject(objectID: objectID,
                         classType: .layoutConstraint,
                         rawClassValue: "IBUILayoutConstraint",
                         content: content)
    }
    
}
