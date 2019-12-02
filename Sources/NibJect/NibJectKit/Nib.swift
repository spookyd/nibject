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
    public var objects: NibObjects
    
    public var topLevelView: NibObject? {
        let topObjectID = hierarchy.objectID
        return objects.first(where: { $0.objectID == topObjectID })
    }
    
    public var topLevelSubviews: NibObjects {
        let subviewObjectIDs = hierarchy.children.map({ $0.objectID })
        let views = filteredObjects(by: .view)
        return views.filter({ subviewObjectIDs.contains($0.objectID) })
    }
    
    public func filteredObjects(by type: NibObject.ClassType) -> NibObjects {
        return objects.filter({ $0.classType == type })
    }
    
    public func filteredHierarchy(by type: NibObject.ClassType) -> [NibHierarchy] {
        return hierarchy.children.filter({ child in
            guard let object = self.objects.first(where: { $0.objectID == child.objectID }),
                object.classType == .view  else {
                return false
            }
            return true            
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
        let objects: NibObjects
        switch NibObjects.from(plist) {
        case .success(let nibObjects):
            objects = nibObjects
        case .failure(let error):
            return .failure(.parsingReason(reason: .objectsParsingFailure(error: error)))
        }
        return .success(Nib(hierarchy: hierarchy, objects: objects))
    }
    
}


