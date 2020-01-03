//
//  IBUIView.swift
//  
//
//  Created by Luke Davis on 12/2/19.
//

import Foundation
import CodeWriter

public enum IBUIViewError: Error {
    case noTopLevelViewInHierarchy([NibHierarchy])
    case objectNotFound(objectID: Nib.ObjectID)
}

public class IBUIView: CustomStringConvertible {
    
    public let objectID: Nib.ObjectID
    public let label: String
    public let name: String
    let rawData: NibObject
    
    private(set) var layoutGuide: IBLayoutGuide?
    public private(set) weak var parent: IBUIView?
    public private(set) var subviews: [IBUIView] = []
    
    public private(set) var constraints: [IBLayoutConstraint] = []
    
    public var uikitRepresentation: String {
        return rawData.rawClassValue.replacingOccurrences(of: "IB", with: "")
    }
    
    var printableName: String {
        // Validate valid characters
        if name.isEmpty {
            return label
        }
        return name
    }
    
    var propertyName: String {
        return printableName.lowerCamelCased
    }
    
    var shouldUsePropertyName: Bool {
        return !isTopLevelView
    }
    
    var isTopLevelView: Bool {
        return parent == nil
    }
    
    var hasSafeArea: Bool {
        return layoutGuide != nil
    }
    
    public init(label: String, name: String, nibObject: NibObject) {
        self.label = label
        self.name = name
        self.objectID = nibObject.objectID
        self.rawData = nibObject
    }
    
    public func addSubview(_ subview: IBUIView) {
        subview.parent = self
        self.subviews.append(subview)
    }
    
    public func addConstraints(_ constraints: [IBLayoutConstraint]) {
        self.constraints.append(contentsOf: constraints)
    }
    
    func addSubviewMethodName() -> String {
        return "addSubview"
    }
    
    public var description: String {
        if constraints.isEmpty {
            return "View(\(objectID))"
        }
        return "View(\(objectID)): Comnstraints -> \(constraints)"
    }
    
    func printGraph() {
        let graph = IBUIViewGraph(view: self).toArray()
        for (idx, level) in graph.enumerated() {
            print("Level \(idx + 1)")
            for view in level {
                print(view)
            }
        }
    }
    
}

// MARK: - Search
extension IBUIView {
    
    public func findDistantRelative(for objectID: Nib.ObjectID) -> IBUIView? {
        return IBUIViewGraph(view: self).findDistantRelative(for: objectID)
    }
    
}

// MARK: - Builder
extension IBUIView {
    
    public static func from(nib: Nib) throws -> IBUIView {
        // For now only support single view
        guard let hierarchy = nib.hierarchy.first else { throw IBUIViewError.noTopLevelViewInHierarchy(nib.hierarchy) }
        let viewObjects = nib.objects.filter({ $0.value.classType == .view || $0.value.classType == .layoutGuide })
        return try self.from(hierarchy: hierarchy, with: viewObjects)
    }
    
    private static func from(hierarchy: NibHierarchy, with objectLookup: [Nib.ObjectID: NibObject]) throws -> IBUIView {
        let parent = try self.from(hierarchy: hierarchy, objectLookup: objectLookup)
        for child in hierarchy.children {
            guard let object = objectLookup[child.objectID] else {
                continue
            }
            if object.classType == .layoutGuide {
                let safeArea = IBLayoutGuide(objectID: object.objectID, name: child.name)
                parent.layoutGuide = safeArea
                // Do not add safe area as a child
                continue
            }
            let childView: IBUIView
            if child.children.isEmpty {
                childView = try self.from(hierarchy: child, objectLookup: objectLookup)
            } else {
                childView = try self.from(hierarchy: child, with: objectLookup)
            }
            parent.addSubview(childView)
        }
        return parent
    }
    
    private static func from(hierarchy: NibHierarchy, objectLookup: [Nib.ObjectID: NibObject]) throws -> IBUIView {
        guard let object = objectLookup[hierarchy.objectID] else {
            throw IBUIViewError.objectNotFound(objectID: hierarchy.objectID)
        }
        // TODO: Get `ibExternalExplicitTranslatesAutoresizingMaskIntoConstraints` for checking translates to auto resize
        // TODO: Get `ibExternalExplicitLabel`
        switch object.rawClassValue {
        case "IBUIStackView": return IBUIStackView(label: hierarchy.label, name: hierarchy.name, nibObject: object)
        case "IBUIButton": return IBUIButton(label: hierarchy.label, name: hierarchy.name, nibObject: object)
        default: return IBUIView(label: hierarchy.label, name: hierarchy.name, nibObject: object)
        }
    }
    
}

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

