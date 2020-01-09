//
//  File.swift
//  
//
//  Created by Luke Davis on 11/30/19.
//

import Foundation

public enum NibObjectError: Error {
    case missingObjectID
    case missingClassType
    case missingClassDetails

    public var localizedDescription: String {
        switch self {
        case .missingObjectID: return "Missing required key 'objectID'"
        case .missingClassType: return "Missing class type"
        case .missingClassDetails: return "Missing class details"
        }
    }
}

public typealias NibObjects = [NibObject]

public struct NibObject {
    public var objectID: String
    public var classType: ClassType
    var rawClassValue: String
    var content: [AnyHashable: Any]
}

extension NibObject {
    enum CodingKeys: String, CodingKey {
        case classType = "class"
    }
    public enum ClassType {
        case view
        case layoutGuide
        case layoutConstraint
        case unknown
    }
}

extension NibObject {
    static func from(_ objectID: String, and dictionary: [AnyHashable: Any]) -> Result<NibObject, NibObjectError> {
        guard let classTypeString = dictionary[CodingKeys.classType.stringValue] as? String else {
            return .failure(.missingClassType)
        }
        var classType = ClassType.unknown
        if classTypeString == "IBLayoutConstraint" {
            classType = .layoutConstraint
        } else if classTypeString == "IBUIViewAutolayoutGuide" {
            classType = .layoutGuide
        } else if classTypeString.contains("IBUI") {
            classType = .view
        }
        return .success(NibObject(objectID: objectID,
                                  classType: classType,
                                  rawClassValue: classTypeString,
                                  content: dictionary))
    }
}

public extension NibObjects {
    static func from(_ plist: InterfaceBuilderPlist) -> Result<NibObjects, NibObjectError> {
        var objects: NibObjects = []
        for object in plist.objects {
            guard let objectID = object.key as? String else { return .failure(.missingObjectID) }
            guard let content = object.value as? [AnyHashable: Any] else { return .failure(.missingClassDetails) }
            switch NibObject.from(objectID, and: content) {
            case .success(let nibObject): objects.append(nibObject)
            case .failure(let error): return .failure(error)
            }
        }
        return .success(objects)
    }
}
