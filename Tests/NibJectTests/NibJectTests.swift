import Files
import XCTest
@testable import NibJect

final class NibJectTests: XCTestCase {
    func testOutputSwiftFile() throws {
        let title = "SingleSubviewView"
        let filePath = URL.resources.appendingPathComponent("\(title).xib").path
        let outputPath = Folder.temporary.path
        NibJect.ejectNib(at: filePath, to: outputPath)
        let exists = try Folder(path: outputPath).containsFile(named: "\(title).swift")
        XCTAssertTrue(exists)
    }
    
    func testGeneratedSwiftFileHasHeaderDoc() throws {
        let fileName = "SingleSubviewView"
        let filePath = URL.resources.appendingPathComponent("\(fileName).xib").path
        let outputPath = Folder.temporary.path
        NibJect.ejectNib(at: filePath, to: outputPath)
        let content = try File(path: "\(outputPath)/\(fileName).swift").readAsString().components(separatedBy: "\n")
        let expectedTitle = "//  \(fileName).swift"
        let expectedAccreditation = "//  Created with ❤️ using NibJect by Luke Davis"
        // Line 2 of Swift file
        XCTAssertEqual(content[1], expectedTitle)
        // Line 5 of Swift file
        XCTAssertEqual(content[4], expectedAccreditation)
    }
    
    func testNoSubviewsContent() throws {
        let fileName = "NoSubviewsView"
        let expected = try loadExpectedOutput(fileName)
        let actual = try runNibject(for: fileName)
        XCTAssertEqual(actual, expected)
    }
    
    func testGeneratedSwiftContainsSubviews() throws {
        let fileName = "SingleSubviewView"
        let expected = try loadExpectedOutput(fileName)
        let actual = try runNibject(for: fileName)
        XCTAssertEqual(actual, expected)
    }
    
    func testSiblingSubviews() throws {
        let fileName = "SiblingSubviewsView"
        let expected = try loadExpectedOutput(fileName)
        let actual = try runNibject(for: fileName)
        XCTAssertEqual(actual, expected)
    }
    
    func testDeepHierarchyView() throws {
        let fileName = "DeepHierarchyView"
        let expected = try loadExpectedOutput(fileName)
        let actual = try runNibject(for: fileName)
        XCTAssertEqual(actual, expected)
    }

    func testComplexView() throws {
        let fileName = "ComplexView"
        let expected = try loadExpectedOutput(fileName)
        let actual = try runNibject(for: fileName)
        XCTAssertEqual(actual, expected)
    }
    
    private func loadExpectedOutput(_ fileName: String) throws -> String {
        return try File(path: URL.resources.appendingPathComponent("\(fileName).swift").path).readAsString()
    }
    
    private func runNibject(for fileName: String) throws -> String {
        let filePath = URL.resources.appendingPathComponent("\(fileName).xib").path
        let outputPath = Folder.temporary.path
        _ = try NibJect.ejectNib(at: filePath, to: outputPath).get()
        return try File(path: "\(outputPath)/\(fileName).swift").readAsString()
    }

}
