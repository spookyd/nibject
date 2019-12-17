//
//  InterfaceBuilderPlistTests.swift
//  
//
//  Created by Luke Davis on 11/29/19.
//

import XCTest
@testable import NibJect

final class InterfaceBuilderPlistTests: XCTestCase {
    func testLoadsNibData() {
        let filePath = URL.resources.appendingPathComponent("SimpleView.xib").path
        let actual = InterfaceBuilderPlist.from(filePath)
        switch actual {
        case .success(let plist):
            XCTAssertFalse(plist.classes.isEmpty)
            XCTAssertFalse(plist.hierarchy.isEmpty)
            XCTAssertFalse(plist.objects.isEmpty)
        default:
            XCTFail("Expected file to be read")
        }
    }
    
    func testInvalidNibData() {
        let filePath = URL.resources.appendingPathComponent("InvalidTestView.xib").path
        let actual = InterfaceBuilderPlist.from(filePath)
        switch actual {
        case .success:
            XCTFail("Expected No file to be found")
        case .failure(let error):
            guard case InterfaceBuilderPlistError.fileNotFound = error else {
                XCTFail("Expected a file not found error")
                return
            }
        }
    }

}
