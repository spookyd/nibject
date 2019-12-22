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

public typealias CodeBlock = String

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
    
    public func generateLazyProperty() -> Property {
        let subclass = uikitRepresentation
        return Property(rawValue: """
        private lazy var \(propertyName): \(subclass) = {
            let view = \(subclass)()
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        """)
    }
    
    func addSubviewCallBuilder() -> FunctionCallBuilder {
        return FunctionCallBuilder(named: "addSubview")
    }
    
    func generateAddSubview() -> FunctionCall {
        guard let parent = self.parent else {
            return FunctionCall(rawValue: "")
        }
        let functionCall = addSubviewCallBuilder()
            .parameter(label: .none, name: propertyName)
            .complete()
        if parent.isTopLevelView {
            return functionCall
        }
        return FunctionCall(rawValue: "\(parent.propertyName).\(functionCall.output)")
    }
    
    func makeLayoutSubView() -> String {
        return "layout\(printableName.upperCamelCased)"
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
    
    /// Searches down the view graph for a descendent matching the object id.
    /// Uses DFS for discovery.
    /// - Parameter objectID: The object id of the view to find
    public func findView(with objectID: Nib.ObjectID) -> IBUIView? {
        return IBUIViewGraph(view: self).findView(with: objectID)
    }
    
}

// MARK: - Builder
extension IBUIView {
    
    public static func from(nib: Nib) throws -> IBUIView {
        // For now only support single view
        guard let hierarchy = nib.hierarchy.first else { throw IBUIViewError.noTopLevelViewInHierarchy(nib.hierarchy) }
        let viewObjects = nib.objects.filter({ $0.value.classType == .view || $0.value.classType == .layoutGuide })
        var constraintObjects = nib.objects
            .filter({ $0.value.classType == .layoutConstraint })
            .map({ IBLayoutConstraint.make(for: $0.value) })
        return try self.from(hierarchy: hierarchy, with: viewObjects, and: &constraintObjects)
    }
    
    private static func from(hierarchy: NibHierarchy,
                             with objectLookup: [Nib.ObjectID: NibObject],
                             and availableConstraints: inout [IBLayoutConstraint]) throws -> IBUIView {
        let parent = try self.from(hierarchy: hierarchy, objectLookup: objectLookup)
        var subviewsToAdd: [IBUIView] = []
        for child in hierarchy.children.reversed() {
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
                // Luke, you need to traverse down the view graph before add constraints.
                // Adding suvies and constraints might need to be separate operations
                /*
                 if view has subviews
                    unitl view has no subviews
                 Add constraints for view
                    
                 */
                childView = try self.from(hierarchy: child, with: objectLookup, and: &availableConstraints)
//                let constraints = self.findConstraints(for: child.objectID, &availableConstraints)
//                childView.addConstraints(constraints)
            }
            subviewsToAdd.append(childView)
        }
        for child in subviewsToAdd.reversed() {
            parent.addSubview(child)
        }
        return parent
    }
    
    private static func from(hierarchy: NibHierarchy, objectLookup: [Nib.ObjectID: NibObject]) throws -> IBUIView {
        guard let object = objectLookup[hierarchy.objectID] else {
            throw IBUIViewError.objectNotFound(objectID: hierarchy.objectID)
        }
        switch object.rawClassValue {
        case "IBUIStackView": return IBUIStackView(label: hierarchy.label, name: hierarchy.name, nibObject: object)
        case "IBUIButton": return IBUIButton(label: hierarchy.label, name: hierarchy.name, nibObject: object)
        default: return IBUIView(label: hierarchy.label, name: hierarchy.name, nibObject: object)
        }
    }
    
    private static func findConstraints(for objectID: Nib.ObjectID,
                                        _ availableConstraints: inout [IBLayoutConstraint]) -> [IBLayoutConstraint] {
        var constraintsToRemove: [Int] = []
        var constraints: [IBLayoutConstraint] = []
        for (idx, constraint) in availableConstraints.enumerated() {
            if constraint.firstItemID == objectID {
                constraintsToRemove.append(idx)
                constraints.append(constraint)
            } else if let secondItem = constraint.secondItemID, secondItem == objectID {
                constraintsToRemove.append(idx)
                constraints.append(constraint)
            }
        }
        for removeIdx in constraintsToRemove.reversed() {
            availableConstraints.remove(at: removeIdx)
        }
        return constraints
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

