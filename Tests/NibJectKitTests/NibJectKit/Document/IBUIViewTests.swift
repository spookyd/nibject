//
//  IBUIViewTests.swift
//  
//
//  Created by Luke Davis on 12/16/19.
//

import XCTest
@testable import NibJectKit

final class IBUIViewTests: XCTestCase {
    
    func testFrom() throws {
        let topUUID = UUID().uuidString
        let child1UUID = UUID().uuidString
        let child2UUID = UUID().uuidString
        let child3UUID = UUID().uuidString
        let child3 = NibHierarchy(objectID: child3UUID, label: "Child3", name: "", children: [])
        let child2 = NibHierarchy(objectID: child2UUID, label: "Child2", name: "", children: [child3])
        let child1 = NibHierarchy(objectID: child1UUID, label: "Child1", name: "", children: [child2])
        let topLevel = NibHierarchy(objectID: topUUID, label: "Top", name: "", children: [child1])
        let nib = Nib(hierarchy: [topLevel], objects: [
            topUUID: NibObject(objectID: topUUID, classType: .view, rawClassValue: "UIView", content: [:]),
            child1UUID: NibObject(objectID: child1UUID, classType: .view, rawClassValue: "UIView", content: [:]),
            child2UUID: NibObject(objectID: child2UUID, classType: .view, rawClassValue: "UIView", content: [:]),
            child3UUID: NibObject(objectID: child3UUID, classType: .view, rawClassValue: "UIView", content: [:])
        ])
        let view = try IBUIView.from(nib: nib)
        XCTAssertFalse(view.subviews.isEmpty)
        let actual1 = try XCTUnwrap(view.subviews.first)
        XCTAssertEqual(actual1.objectID, child1UUID)
        XCTAssertEqual(actual1.parent?.objectID, topUUID)
        XCTAssertFalse(actual1.subviews.isEmpty)
        let actual2 = try XCTUnwrap(actual1.subviews.first)
        XCTAssertEqual(actual2.parent?.objectID, actual1.objectID)
        XCTAssertFalse(actual2.subviews.isEmpty)
        let actual3 = try XCTUnwrap(actual2.subviews.first)
        XCTAssertEqual(actual3.parent?.objectID, actual2.objectID)
    }
    
    func testFromWithConstraints() throws {
        let topUUID = UUID().uuidString
        let child1UUID = UUID().uuidString
        let child2UUID = UUID().uuidString
        let child3UUID = UUID().uuidString
        let child3 = NibHierarchy(objectID: child3UUID, label: "Child3", name: "", children: [])
        let child2 = NibHierarchy(objectID: child2UUID, label: "Child2", name: "", children: [])
        let child1 = NibHierarchy(objectID: child1UUID, label: "Child1", name: "", children: [child2, child3])
        let topLevel = NibHierarchy(objectID: topUUID, label: "Top", name: "", children: [child1])
        let nib = Nib(hierarchy: [topLevel], objects: [
            topUUID: NibObject.makeView(topUUID),
            child1UUID: NibObject.makeView(child1UUID),
            child2UUID: NibObject.makeConstraint(child2UUID, firstItem: child1UUID, secondItem: topUUID),
            child3UUID: NibObject.makeConstraint(child3UUID, firstItem: topUUID, secondItem: child1UUID)
        ])
        let view = try IBUIView.from(nib: nib)
        let graph = IBUIViewGraph(view: view).flattenHierarchy()
        let constraints = IBLayoutConstraint.from(nib: nib)
        ConstraintBuilder(flattendView: graph).assign(constraints: constraints)
        XCTAssertTrue(view.constraints.isEmpty)
        let child = try XCTUnwrap(view.subviews.first)
        XCTAssertEqual(child.constraints.count, 2)
    }

}
