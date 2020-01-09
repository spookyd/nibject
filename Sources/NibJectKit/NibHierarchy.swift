//
//  NibHierarchy.swift
//  
//
//  Created by Luke Davis on 11/29/19.
//

import Foundation

public enum NibHierarchyError: Error {
    case viewNotFound
}

public struct NibHierarchy: Hashable {
    public var objectID: String
    public var label: String
    public var name: String
    public var children: [NibHierarchy]
}

extension NibHierarchy {
    enum CodingKeys: String, CodingKey {
        case objectID = "object-id"
        case label = "label"
        case name = "name"
        case children = "children"
    }

    public static let fileOwnerObjectID = "-1"
    public static let firstResponderObjectID = "-2"
}

public extension NibHierarchy {

    func find(_ objectID: String) -> NibHierarchy? {
        if self.objectID == objectID { return self }
        for child in children {
            if let found = child.find(objectID) {
                return found
            }
        }
        return .none
    }

    /// Only supports one view per nib
    static func from(_ plist: InterfaceBuilderPlist) -> Result<[NibHierarchy], NibHierarchyError> {
        guard let hierarchy = plist.hierarchy as? [[AnyHashable: Any]] else {
            fatalError("The ibTool formatting must have changed for `hierarchy`. Expected an array of dictionaries")
        }
        let topLevelViews = hierarchy.map({ parse($0) }).filter({
            $0.objectID != self.fileOwnerObjectID && $0.objectID != self.firstResponderObjectID
        })
        if topLevelViews.isEmpty { return .failure(.viewNotFound) }
        return .success(topLevelViews)
    }

    private static func parse(_ dictionary: [AnyHashable: Any]) -> NibHierarchy {
        let objectID = dictionary[CodingKeys.objectID.stringValue] as? String ?? ""
        let label = dictionary[CodingKeys.label.stringValue] as? String ?? ""
        let name = dictionary[CodingKeys.name.stringValue] as? String ?? ""
        let rawChildren = dictionary[CodingKeys.children.stringValue] as? [[AnyHashable: Any]] ?? []
        let children = rawChildren.map({ parse($0) })
        return NibHierarchy(objectID: objectID, label: label, name: name, children: children)
    }
}

public extension Array where Element == NibHierarchy {
    func find(_ objectID: Nib.ObjectID) -> NibHierarchy? {
        for view in self {
            if let found = view.find(objectID) { return found }
        }
        return .none
    }
}
