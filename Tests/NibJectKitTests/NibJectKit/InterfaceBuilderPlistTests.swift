//
//  InterfaceBuilderPlistTests.swift
//  
//
//  Created by Luke Davis on 11/29/19.
//

@testable import NibJectKit
import XCTest

final class InterfaceBuilderPlistTests: XCTestCase {
    func testLoadsNibData() {
        let filePath = URL.resources.appendingPathComponent("SingleSubviewView.xib").path
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

}
