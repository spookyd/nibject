//
//  NibTests.swift
//  
//
//  Created by Luke Davis on 11/25/19.
//

import XCTest
@testable import NibJect

final class NibTests: XCTestCase {
    func testTopLevelView() throws {
        let childView = NibHierarchy(objectID: UUID().uuidString, label: "Child View", name: "", children: [])
        let childObject = NibObject(objectID: childView.objectID, classType: .view, content: [:])
        let topLevelView = NibHierarchy(objectID: UUID().uuidString, label: "Top Level View", name: "", children: [childView])
        let topLevelObject = NibObject(objectID: topLevelView.objectID, classType: .view, content: [:])
        let objects = [topLevelObject.objectID: topLevelObject, childObject.objectID: childObject]
        let nib = Nib(hierarchy: topLevelView, objects: objects)
        let actual = try XCTUnwrap(nib.topLevelView)
        XCTAssertEqual(actual.objectID, topLevelObject.objectID)
    }
    
    func testTopLevelSubviews() throws {
        let childView = NibHierarchy(objectID: UUID().uuidString, label: "Child View", name: "", children: [])
        let childObject = NibObject(objectID: childView.objectID, classType: .view, content: [:])
        let topLevelView = NibHierarchy(objectID: UUID().uuidString, label: "Top Level View", name: "", children: [childView])
        let topLevelObject = NibObject(objectID: topLevelView.objectID, classType: .view, content: [:])
        let objects = [topLevelObject.objectID: topLevelObject, childObject.objectID: childObject]
        let nib = Nib(hierarchy: topLevelView, objects: objects)
        let actual = nib.topLevelChildrenObjects()
        XCTAssertEqual(actual.count, 1)
        let actualFirst = try XCTUnwrap(actual.first)
        XCTAssertEqual(actualFirst.objectID, childObject.objectID)
    }
    
}
