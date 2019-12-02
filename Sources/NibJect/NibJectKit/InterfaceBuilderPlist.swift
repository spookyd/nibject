//
//  InterfaceBuilderPlist.swift
//  
//
//  Created by Luke Davis on 11/25/19.
//

import Foundation

public enum InterfaceBuilderPlistError: Error {
    case fileNotFound
    case fileReadFailure(underlyingError: Error)
    case deserializationFailure(underlyingError: Error)
}

public struct InterfaceBuilderPlist {
    public var classes: [AnyHashable: Any]
    public var connections: [AnyHashable: Any]
    public var hierarchy: [Any]
    public var objects: [AnyHashable: Any]
    
}

public extension InterfaceBuilderPlist {
    enum CodingKeys: String, CodingKey {
        case classes = "com.apple.ibtool.document.classes"
        case connections = "com.apple.ibtool.document.connections"
        case hierarchy = "com.apple.ibtool.document.hierarchy"
        case objects = "com.apple.ibtool.document.objects"
        case errors = "com.apple.ibtool.errors"
    }
}

extension InterfaceBuilderPlist {
    
    public static func from(_ filePath: String, using ibTool: IBTool = IBTool()) -> Result<InterfaceBuilderPlist, InterfaceBuilderPlistError> {
        switch ibTool.run(filePath, [.classes, .connections, .hierarchy, .objects]) {
        case .success(let data):
            do {
                guard let dictionary = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: .none) as? [AnyHashable: Any] else {
                    fatalError("Invalid casting. Run `ibtool` to see if the format output has changed.")
                }
                let classes = dictionary[CodingKeys.classes.stringValue] as? [AnyHashable: Any] ?? [:]
                let connections = dictionary[CodingKeys.connections.stringValue] as? [AnyHashable: Any] ?? [:]
                let hierarchy = dictionary[CodingKeys.hierarchy.stringValue] as? [Any] ?? []
                let objects = dictionary[CodingKeys.objects.stringValue] as? [AnyHashable: Any] ?? [:]
                let errors = dictionary[CodingKeys.errors.stringValue] as? [Any] ?? []
                guard errors.isEmpty else {
                    return .failure(InterfaceBuilderPlistError.fileNotFound)
                }
                let plist = InterfaceBuilderPlist(classes: classes,
                                                  connections: connections,
                                                  hierarchy: hierarchy,
                                                  objects: objects)
                return .success(plist)
            } catch {
                return .failure(.deserializationFailure(underlyingError: error))
            }
        case .failure(let error):
            return .failure(.fileReadFailure(underlyingError: error))
        }
    }
}

