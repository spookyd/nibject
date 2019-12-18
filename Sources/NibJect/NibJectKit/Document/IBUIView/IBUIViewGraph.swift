//
//  IBUIViewGraph.swift
//  
//
//  Created by Luke Davis on 12/17/19.
//

import Foundation

class IBUIViewGraph {
    
    private var view: IBUIView
    init(view: IBUIView) {
        self.view = view
    }
    
    public func findDistantRelative(for objectID: Nib.ObjectID) -> IBUIView? {
        return searchRelatives(for: objectID, startingAt: self.view)
    }
    
    private func searchRelatives(for objectID: Nib.ObjectID, startingAt node: IBUIView) -> IBUIView? {
        if node.objectID == objectID { return node }
        guard let parent = node.parent else { return .none }
        // Work around for safe area
        if parent.hasSafeArea && parent.layoutGuide?.objectID == objectID { return parent }
        return searchRelatives(for: objectID, startingID: node.objectID, in: parent)
    }
    
    private func searchRelatives(for objectID: Nib.ObjectID, startingID: Nib.ObjectID, in node: IBUIView) -> IBUIView? {
        if node.objectID == objectID { return node }
        for child in node.subviews {
            if child.objectID == startingID { continue }
            if child.objectID == objectID { return child }
            if child.subviews.isEmpty { continue }
            guard let found = findView(with: objectID, in: child) else { continue }
            return found
        }
        guard let parent = node.parent else { return .none }
        // Work around for safe area
        if parent.hasSafeArea && parent.layoutGuide?.objectID == objectID { return parent }
        return searchRelatives(for: objectID, startingID: startingID, in: parent)
    }
    
    /// Searches down the view graph for a descendent matching the object id.
    /// Uses DFS for discovery.
    /// - Parameter objectID: The object id of the view to find
    public func findView(with objectID: Nib.ObjectID) -> IBUIView? {
        return findView(with: objectID, in: self.view)
    }
    
    private func findView(with objectID: Nib.ObjectID, in node: IBUIView) -> IBUIView? {
        if node.objectID == objectID { return node }
        for child in node.subviews {
            if let found = findView(with: objectID, in: child) { return found }
        }
        return .none
    }
}
