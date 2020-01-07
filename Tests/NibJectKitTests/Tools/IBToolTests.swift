//
//  File.swift
//  
//
//  Created by Luke Davis on 11/29/19.
//

import Files
import XCTest
@testable import NibJectKit

final class IBToolsTests: XCTestCase {
    func testReadsNibFile() {
        let filePath = URL.resources.appendingPathComponent("ImportTestView.xib").path
        let actual = IBTool().run(filePath, [.classes, .connections, .hierarchy, .objects])
        switch actual {
        case .success(let data):
            XCTAssertFalse(data.isEmpty)
        default:
            XCTFail("Expected file to be read")
        }
    }

}
