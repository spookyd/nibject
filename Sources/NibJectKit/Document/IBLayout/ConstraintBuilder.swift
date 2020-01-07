//
//  ConstraintBuilder.swift
//  
//
//  Created by Luke Davis on 1/7/20.
//

import Foundation

/// Will take a flattened view hierarchy and assign the constraints to the correct views
class ConstraintBuilder {
    let flattendView: [IBUIView]
    
    init(flattendView: [IBUIView]) {
        self.flattendView = flattendView
    }
    
    func assign(constraints: [IBLayoutConstraint]) {
        var usedConstraints: [Nib.ObjectID] = []
        for view in flattendView.reversed() {
            if usedConstraints.count == constraints.count { return }
            let matchedConstraints = constraints.filter({
                !usedConstraints.contains($0.objectID)
                    && ($0.firstItemID == view.objectID || $0.secondItemID == view.objectID)
            })
            if matchedConstraints.isEmpty { continue }
            view.addConstraints(matchedConstraints)
            usedConstraints.append(contentsOf: matchedConstraints.map({ $0.objectID }))
        }
    }
    
}
