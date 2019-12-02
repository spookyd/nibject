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
    /// Only supports one view per nib
    static func from(_ plist: InterfaceBuilderPlist) -> Result<NibHierarchy, NibHierarchyError> {
        guard let hierarchy = plist.hierarchy as? [[AnyHashable: Any]] else {
            fatalError("The ibTool formatting must have changed for `hierarchy`. Expected an array of dictionaries")
        }
        let views = hierarchy.map({ parse($0) })
        guard let firstView = views.first(where: {
            $0.objectID != self.fileOwnerObjectID && $0.objectID != self.firstResponderObjectID
        }) else { return .failure(.viewNotFound) }
        return .success(firstView)
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


