//
//  NibObjectTests.swift
//
//
//  Created by Luke Davis on 11/30/19.
//

@testable import NibJectKit
import XCTest

final class NibObjectTests: XCTestCase {

    func testFrom() {
        let objectID = UUID().uuidString
        let expected: [AnyHashable: Any] = ["class": "IBUIView"]
        let result = NibObject.from(objectID, and: expected)
        switch result {
        case .success(let actual):
            XCTAssertEqual(actual.objectID, objectID)
            XCTAssertEqual(actual.classType, .view)
        default:
            XCTFail("Expected to be successful")
        }
    }

    func testFrom_ViewType() throws {
        let expected: [AnyHashable: Any] = ["class": "IBUI\(UUID().uuidString)"]
        let result = NibObject.from("0gL-9z-1oC", and: expected)
        switch result {
        case .success(let actual):
            XCTAssertEqual(actual.classType, NibObject.ClassType.view)
        default:
            XCTFail("Expected to be successful")
        }
    }

    func testFrom_layoutGuideType() throws {
        let expected: [AnyHashable: Any] = ["class": "IBUIViewAutolayoutGuide"]
        let result = NibObject.from("0gL-9z-1oC", and: expected)
        switch result {
        case .success(let actual):
            XCTAssertEqual(actual.classType, NibObject.ClassType.layoutGuide)
        default:
            XCTFail("Expected to be successful")
        }
    }

    func testFrom_layoutConstraintType() throws {
        let expected: [AnyHashable: Any] = ["class": "IBLayoutConstraint"]
        let result = NibObject.from("0gL-9z-1oC", and: expected)
        switch result {
        case .success(let actual):
            XCTAssertEqual(actual.classType, NibObject.ClassType.layoutConstraint)
        default:
            XCTFail("Expected to be successful")
        }
    }

    func testFrom_unknownType() throws {
        let expected: [AnyHashable: Any] = ["class": UUID().uuidString]
        let result = NibObject.from("0gL-9z-1oC", and: expected)
        switch result {
        case .success(let actual):
            XCTAssertEqual(actual.classType, NibObject.ClassType.unknown)
        default:
            XCTFail("Expected to be successful")
        }
    }

    func testFrom_missingClassType() {
        let objectID = UUID().uuidString
        let expected: [AnyHashable: Any] = [:]
        let result = NibObject.from(objectID, and: expected)
        switch result {
        case .failure(let error):
            guard case NibObjectError.missingClassType = error else {
                XCTFail("Invalid error type")
                return
            }
        default:
            XCTFail("Expected to be failure")
        }
    }

}
