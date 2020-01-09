//
//  InterfaceBuilderPlist.swift
//  
//
//  Created by Luke Davis on 11/25/19.
//

import Foundation

public struct IBToolError: Error {
    var description: String
    init?(rawValue: [AnyHashable: Any]) {
        guard let description = rawValue["description"] as? String else {
            return nil
        }
        self.description = description
    }
    public var localizedDescription: String {
        return description
    }
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

    public static func from(_ filePath: String,
                            using ibTool: IBTool = IBTool()) -> Result<InterfaceBuilderPlist, NibjectError> {
        switch ibTool.run(filePath, [.classes, .connections, .hierarchy, .objects]) {
        case .success(let data):
            do {
                let deserializedPlist = try PropertyListSerialization.propertyList(from: data,
                                                                                   options: .mutableContainers,
                                                                                   format: .none)
                guard let dictionary = deserializedPlist as? [AnyHashable: Any] else {
                    fatalError("Invalid casting. Run `ibtool` to see if the format output has changed.")
                }
                let classes = dictionary[CodingKeys.classes.stringValue] as? [AnyHashable: Any] ?? [:]
                let connections = dictionary[CodingKeys.connections.stringValue] as? [AnyHashable: Any] ?? [:]
                let hierarchy = dictionary[CodingKeys.hierarchy.stringValue] as? [Any] ?? []
                let objects = dictionary[CodingKeys.objects.stringValue] as? [AnyHashable: Any] ?? [:]
                let errors = dictionary[CodingKeys.errors.stringValue] as? [[AnyHashable: Any]] ?? []
                let transformedErrors = errors.compactMap(IBToolError.init)
                guard transformedErrors.isEmpty else {
                    let messages = transformedErrors.map({ $0.localizedDescription })
                    return .failure(.interfaceBuilderParsingError(reason: .ibtoolInputFailure(errorMessages: messages)))
                }
                let plist = InterfaceBuilderPlist(classes: classes,
                                                  connections: connections,
                                                  hierarchy: hierarchy,
                                                  objects: objects)
                return .success(plist)
            } catch {
                return .failure(.interfaceBuilderParsingError(reason: .deserializationFailure(underlyingError: error)))
            }
        case .failure(let error):
            return .failure(.interfaceBuilderParsingError(reason: .ibtoolFailure(underlyingError: error)))
        }
    }
}
