//
//  NibObjectsTests.swift
//  
//
//  Created by Luke Davis on 11/30/19.
//

@testable import NibJectKit
import XCTest

final class NibObjectsTests: XCTestCase {

    func testFrom() {
        let expected: [AnyHashable: [AnyHashable: Any]] = [
            "0gL-9z-1oC": ["class": "IBUIView"]
        ]
        let plist = InterfaceBuilderPlist(classes: [:], connections: [:], hierarchy: [], objects: expected)
        let result = NibObjects.from(plist)
        switch result {
        case .success(let actual):
            XCTAssertEqual(actual.count, expected.count)
        default:
            XCTFail("Expected to be successful")
        }
    }

    func testFrom_invalidKey() {
        let expected: [AnyHashable: [AnyHashable: Any]] = [
            123: ["class": "IBUIView"]
        ]
        let plist = InterfaceBuilderPlist(classes: [:], connections: [:], hierarchy: [], objects: expected)
        let result = NibObjects.from(plist)
        switch result {
        case .failure(let error):
            guard case NibObjectError.missingObjectID = error else {
                XCTFail("Invalid error type")
                return
            }
        default:
            XCTFail("Expected to be failure")
        }
    }

    func testFrom_invalidContent() {
        let expected: [AnyHashable: Any] = [
            "0gL-9z-1oC": ["123", "asdf"]
        ]
        let plist = InterfaceBuilderPlist(classes: [:], connections: [:], hierarchy: [], objects: expected)
        let result = NibObjects.from(plist)
        switch result {
        case .failure(let error):
            guard case NibObjectError.missingClassDetails = error else {
                XCTFail("Invalid error type")
                return
            }
        default:
            XCTFail("Expected to be successful")
        }
    }

}
