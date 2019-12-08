//
//  GeneratedSwiftFileTests.swift
//  
//
//  Created by Luke Davis on 12/1/19.
//

import XCTest
@testable import NibJect

final class GeneratedSwiftFileTests: XCTestCase {
//    func testTopLevelClass() {
//        let nib = Nib(hierarchy: NibHierarchy(objectID: "", label: "", name: "", children: []), objects: [])
//        let actual = GeneratedSwiftFile(nib: nib, fileName: "TestFile").topLevelClass
//        let expected = "public class TestFile: UIView {"
//        XCTAssertEqual(actual, expected)
//    }
//    
//    func testSubviewPropertyFormatting() throws {
//        let childView = NibHierarchy(objectID: UUID().uuidString, label: "Child View", name: "", children: [])
//        let childObject = NibObject(objectID: childView.objectID, classType: .view, content: [:])
//        let topLevelView = NibHierarchy(objectID: UUID().uuidString, label: "Top Level View", name: "", children: [childView])
//        let topLevelObject = NibObject(objectID: topLevelView.objectID, classType: .view, content: [:])
//        let objects = NibObjects(arrayLiteral: topLevelObject, childObject)
//        let nib = Nib(hierarchy: topLevelView, objects: objects)
//        let swiftFile = try GeneratedSwiftFile.from(nib, named: "TestFile").get()
//        XCTAssertFalse(swiftFile.subviewProperties.isEmpty)
//        let actual = try XCTUnwrap(swiftFile.subviewProperties.first)
//        let expected = """
//        private lazy var childView: UIView = {
//            let view = UIView()
//            view.translatesAutoresizingMaskIntoConstraints = false
//            return view
//        }()
//
//        """
//        XCTAssertEqual(actual, expected)
//    }
//    
//    func testMultipleSubviewProperties() throws {
//        let childView = NibHierarchy(objectID: UUID().uuidString, label: "Child View", name: "", children: [])
//        let childView2 = NibHierarchy(objectID: UUID().uuidString, label: "Child View 2", name: "", children: [])
//        let childObject = NibObject(objectID: childView.objectID, classType: .view, content: [:])
//        let childObject2 = NibObject(objectID: childView2.objectID, classType: .view, content: [:])
//        let topLevelView = NibHierarchy(objectID: UUID().uuidString, label: "Top Level View", name: "", children: [childView, childView2])
//        let topLevelObject = NibObject(objectID: topLevelView.objectID, classType: .view, content: [:])
//        let objects = NibObjects(arrayLiteral: topLevelObject, childObject, childObject2)
//        let nib = Nib(hierarchy: topLevelView, objects: objects)
//        let swiftFile = try GeneratedSwiftFile.from(nib, named: "TestFile").get()
//        XCTAssertEqual(swiftFile.subviewProperties.count, 2)
//        
//        let actualFirst = try XCTUnwrap(swiftFile.subviewProperties.first)
//        let expectedFirst = """
//        private lazy var childView: UIView = {
//            let view = UIView()
//            view.translatesAutoresizingMaskIntoConstraints = false
//            return view
//        }()
//
//        """
//        let actualLast = try XCTUnwrap(swiftFile.subviewProperties.last)
//        let expectedLast = """
//        private lazy var childView2: UIView = {
//            let view = UIView()
//            view.translatesAutoresizingMaskIntoConstraints = false
//            return view
//        }()
//
//        """
//        XCTAssertEqual(actualFirst, expectedFirst)
//        XCTAssertEqual(actualLast, expectedLast)
//    }
}
