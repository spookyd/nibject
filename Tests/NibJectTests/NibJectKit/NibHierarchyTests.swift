//
//  NibHierarchyTests.swift
//  
//
//  Created by Luke Davis on 11/30/19.
//

import XCTest
@testable import NibJect

final class NibHierarchyTests: XCTestCase {
    
    func testFrom() {
        let expected: [Any] = [
            ["label": "File's Owner", "object-id": "-1"],
            ["label": "First Responder", "object-id": "-2"],
            ["label": "View", "object-id": "iN0-l3-epB"]
        ]
        let plist = InterfaceBuilderPlist(classes: [:], connections: [:], hierarchy: expected, objects: [:])
        let result = NibHierarchy.from(plist)
        switch result {
        case .success(let actual):
            // Expected to ignore the first responder and file's owner types
            XCTAssertNotEqual(actual.objectID, "-1")
            XCTAssertNotEqual(actual.objectID, "-2")
        default:
            XCTFail("Expected to be successful")
        }
    }
    
    func testFrom_nestedChildren() throws {
        let expected: [Any] = [
            ["label": "View", "object-id": "iN0-l3-epB", "children":
                [["label": "Safe Area", "object-id": "vUN-kp-3ea"],
                 ["label": "Test Button", "object-id": "90H-07-WoH"],
                 ["label": "Stack View", "object-id": "gFn-0Q-bWM", "children":
                    [["label": "Label", "object-id": "O4V-Dc-Hsc"],
                     ["label": "Label", "object-id": "raG-38-a6z<"],
                     ["label": "Label", "object-id": "tzV-lM-bXl"]]
                    ]
                ]
            ]
        ]
        let plist = InterfaceBuilderPlist(classes: [:], connections: [:], hierarchy: expected, objects: [:])
        let result = NibHierarchy.from(plist)
        switch result {
        case .success(let actual):
            let children = actual.children
            XCTAssertFalse(children.isEmpty)
            let grandChildren = try XCTUnwrap(children.first(where: { !$0.children.isEmpty })).children
            XCTAssertFalse(grandChildren.isEmpty)
        default:
            XCTFail("Expected to be successful")
        }
    }
    
    func testFrom_missingView() {
        let expected: [Any] = [
            ["label": "File's Owner", "object-id": "-1"],
            ["label": "First Responder", "object-id": "-2"]
        ]
        let plist = InterfaceBuilderPlist(classes: [:], connections: [:], hierarchy: expected, objects: [:])
        let result = NibHierarchy.from(plist)
        switch result {
        case .failure(let error):
            guard case NibHierarchyError.viewNotFound = error else {
                XCTFail("Unexpected error returned")
                return
            }
        default:
            XCTFail("Expected to fail")
        }
    }

}