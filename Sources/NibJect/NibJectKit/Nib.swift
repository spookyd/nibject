//
//  Nib.swift
//  
//
//  Created by Luke Davis on 11/25/19.
//

import Foundation

public enum NibError: Error {
    case parsingReason(reason: ParsingReason)
    public enum ParsingReason {
        case hierarchyParsingFailure(error: NibHierarchyError)
        case objectsParsingFailure(error: NibObjectError)
    }
}

public struct Nib {
    public var hierarchy: NibHierarchy
    public var objects: [String: NibObject]
    
    public var topLevelView: NibObject? {
        let topObjectID = hierarchy.objectID
        return objects[topObjectID]
    }
    
    public func topLevelChildrenObjects() -> NibObjects {
        guard let topLevelView = topLevelView else { return [] }
        return childrenObjects(of: topLevelView.objectID)
    }
    
    public func childrenObjects(of objectID: String) -> NibObjects {
        guard let parent = hierarchy.find(objectID) else {
            return []
        }
        return parent.children.compactMap({ objects[$0.objectID] })
    }
    
    public func name(of objectID: String) -> String {
        guard let hierarchy = hierarchy.find(objectID) else {
            return ""
        }
        return hierarchy.name
    }
    
    public func filteredHierarchy(by type: NibObject.ClassType) -> [NibHierarchy] {
        return hierarchy.children.filter({ child in
            guard let object = self.objects[child.objectID] else {
                return false
            }
            return object.classType == .view
        })
    }
    
}

public extension Nib {
    static func from(_ plist: InterfaceBuilderPlist) -> Result<Nib, NibError> {
        let hierarchy: NibHierarchy
        switch NibHierarchy.from(plist) {
        case .success(let nibHierarchy):
            hierarchy = nibHierarchy
        case .failure(let error):
            return .failure(.parsingReason(reason: .hierarchyParsingFailure(error: error)))
        }
        var objects: [String: NibObject] = [:]
        switch NibObjects.from(plist) {
        case .success(let nibObjects):
            objects = nibObjects.reduce(into: objects, {
                $0[$1.objectID] = $1
            })
        case .failure(let error):
            return .failure(.parsingReason(reason: .objectsParsingFailure(error: error)))
        }
        return .success(Nib(hierarchy: hierarchy, objects: objects))
    }
    
}


