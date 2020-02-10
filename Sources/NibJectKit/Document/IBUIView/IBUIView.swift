//
//  IBUIView.swift
//  
//
//  Created by Luke Davis on 12/2/19.
//

import CodeWriter
import Foundation

public enum IBUIViewError: Error {
    // swiftlint:disable identifier_name
    case noTopLevelViewInHierarchy([NibHierarchy])
    case objectNotFound(objectID: Nib.ObjectID)
    // swiftlint:enable identifier_name
}

public class IBUIView: CustomStringConvertible {

    public let objectID: Nib.ObjectID
    /// The label that is set in the Hierarchy Plist
    public let label: String
    /// The name that is set in the HIerarchy Plist
    public let name: String
    let rawData: NibObject

    fileprivate(set) var layoutGuide: IBLayoutGuide?
    public private(set) weak var parent: IBUIView?
    public private(set) var subviews: [IBUIView] = []

    public private(set) var constraints: [IBLayoutConstraint] = []

    public var uikitRepresentation: String {
        return rawData.rawClassValue.replacingOccurrences(of: "IB", with: "")
    }

    public var translatesToAutoResizeMask: Bool {
        guard let value = rawData.content["ibExternalExplicitTranslatesAutoresizingMaskIntoConstraints"] as? Bool else {
            return constraints.isEmpty
        }
        return value
    }
    
    /**
     <key>ibShadowedHorizontalContentCompressionResistancePriority</key>
     <real>750</real>
     */
    public var horizontalContentCompressionResistancePriority: Float {
        guard let value = rawData.content["ibShadowedHorizontalContentCompressionResistancePriority"] as? Float else {
            return defaultHorizontalContentCompressionResistancePriority
        }
        return value
    }
    
    var defaultHorizontalContentCompressionResistancePriority: Float {
        return 750
    }
    
    /**
    <key>ibShadowedHorizontalContentHuggingPriority</key>
    <real>250</real>
     */
    public var horizontalContentHuggingPriority: Float {
        guard let value = rawData.content["ibShadowedHorizontalContentHuggingPriority"] as? Float else {
            return defaultHorizontalContentHuggingPriority
        }
        return value
    }
    
    var defaultHorizontalContentHuggingPriority: Float {
        return 250
    }
    
    /**
     <key>ibShadowedVerticalContentCompressionResistancePriority</key>
     <real>750</real>
     */
    public var verticalContentCompressionResistancePriority: Float {
        guard let value = rawData.content["ibShadowedVerticalContentCompressionResistancePriority"] as? Float else {
            return defaultVerticalContentCompressionResistancePriority
        }
        return value
    }
    
    var defaultVerticalContentCompressionResistancePriority: Float {
        return 750
    }
    
    /**
     <key>ibShadowedVerticalContentHuggingPriority</key>
     <real>250</real>
     */
    public var verticalContentHuggingPriority: Float {
        guard let value = rawData.content["ibShadowedVerticalContentHuggingPriority"] as? Float else {
            return defaultVerticalContentHuggingPriority
        }
        return value
    }
    
    var defaultVerticalContentHuggingPriority: Float {
        return 250
    }

    // swiftlint:disable:next todo
    // TODO: ibExternalUserDefinedRuntimeAttributes
    /*
     Example:
     <key>ibExternalUserDefinedRuntimeAttributes</key>
     <array>
             <dict>
                     <key>keyPath</key>
                     <string>layer.cornerRadius</string>
                     <key>localized</key>
                     <string>NO</string>
                     <key>typeIdentifier</key>
                     <string>com.apple.InterfaceBuilder.userDefinedRuntimeAttributeType.number</string>
                     <key>value</key>
                     <integer>10</integer>
             </dict>
     </array>
     */

    public var customName: String? { rawData.content["ibExternalExplicitLabel"] as? String }

    public var hasCustomName: Bool { customName != nil }

    public var displayName: String {
        if let customName = self.customName { return customName }
        if name.isEmpty {
            return label
        }
        return name
    }

    var propertyName: String {
        return removeIllegalCharacters(from: displayName.lowerCamelCased)
    }

    private func removeIllegalCharacters(from string: String) -> String {
        let validChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_")
        return string.filter({ validChars.contains($0) })
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
        var parser = IBUIViewParser()
        return try parser.parse(nib: nib)
    }

}
// GOAL: Set the IBUIView name when no custom label has been set.
// Need to maintain a map of used property names and add a numeric value after each repeated name
struct IBUIViewParser {

    private var propertyNames: [String: Int] = [:]

    public mutating func parse(nib: Nib) throws -> IBUIView {
        // For now only support single view
        guard let hierarchy = nib.hierarchy.first else { throw IBUIViewError.noTopLevelViewInHierarchy(nib.hierarchy) }
        let viewObjects = nib.objects.filter({ $0.value.classType == .view || $0.value.classType == .layoutGuide })
        return try self.from(hierarchy: hierarchy, with: viewObjects)
    }

    private mutating func from(hierarchy: NibHierarchy,
                               with objectLookup: [Nib.ObjectID: NibObject]) throws -> IBUIView {
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

    private mutating func from(hierarchy: NibHierarchy, objectLookup: [Nib.ObjectID: NibObject]) throws -> IBUIView {
        guard let object = objectLookup[hierarchy.objectID] else {
           throw IBUIViewError.objectNotFound(objectID: hierarchy.objectID)
        }
        let name = generateViewName(for: hierarchy)
        switch object.rawClassValue {
        case "IBUIStackView": return IBUIStackView(label: hierarchy.label, name: name, nibObject: object)
        case "IBUIButton": return IBUIButton(label: hierarchy.label, name: name, nibObject: object)
        case "IBUILabel": return IBUILabel(label: hierarchy.label, name: name, nibObject: object)
        case "IBUISwitch": return IBUISwitch(label: hierarchy.label, name: name, nibObject: object)
        case "IBUIProgressView": return IBUIProgressView(label: hierarchy.label, name: name, nibObject: object)
        case "IBUIStepper": return IBUIStepper(label: hierarchy.label, name: name, nibObject: object)
        case "IBUIActivityIndicatorView": return IBUIActivityIndicatorView(label: hierarchy.label, name: name, nibObject: object)
        case "IBUIImageView": return IBUIImageView(label: hierarchy.label, name: name, nibObject: object)
        default: return IBUIView(label: hierarchy.label, name: name, nibObject: object)
        }
    }

    private mutating func generateViewName(for hierarchy: NibHierarchy) -> String {
        // ASSUMPTION: When no custom label is set in the .xib then the `name` is missing from hierarchy
        var name: String
        if hierarchy.name.isEmpty {
            name = hierarchy.label
        } else {
            name = hierarchy.name
        }
        let nameCount = propertyNames[name, default: 0]
        propertyNames[name] = nameCount + 1
        if nameCount > 0 {
            name = "\(name)\(nameCount)"
        }
        return name
    }
}
