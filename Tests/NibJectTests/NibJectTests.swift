import Files
import XCTest
@testable import NibJect

final class NibJectTests: XCTestCase {
    func testOutputSwiftFile() throws {
        let title = "ImportTestView"
        let filePath = URL.resources.appendingPathComponent("\(title).xib").path
        let outputPath = Folder.temporary.path
        NibJect.ejectNib(at: filePath, to: outputPath)
        let exists = try Folder(path: outputPath).containsFile(named: "\(title).swift")
        XCTAssertTrue(exists)
    }
    
    func testGeneratedSwiftFileHasHeaderDoc() throws {
        let fileName = "SimpleView"
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
    
    func testSimpleViewSwiftFileContent() throws {
        let fileName = "SimpleView"
        let filePath = URL.resources.appendingPathComponent("\(fileName).xib").path
        let outputPath = Folder.temporary.path
        let expected = try File(path: URL.resources.appendingPathComponent("\(fileName).swift").path).readAsString()
        NibJect.ejectNib(at: filePath, to: outputPath)
        let actual = try File(path: "\(outputPath)/\(fileName).swift").readAsString()
        XCTAssertEqual(actual, expected)
    }
    
    func testNoSubviewsContent() throws {
        let fileName = "NoSubviewsView"
        let filePath = URL.resources.appendingPathComponent("\(fileName).xib").path
        let outputPath = Folder.temporary.path
        let expected = try File(path: URL.resources.appendingPathComponent("\(fileName).swift").path).readAsString()
        NibJect.ejectNib(at: filePath, to: outputPath)
        let actual = try File(path: "\(outputPath)/\(fileName).swift").readAsString()
        XCTAssertEqual(actual, expected)
    }
//
//    func testGeneratedSwiftContainsSubviews() throws {
//        let fileName = "SimpleView"
//        let filePath = URL.resources.appendingPathComponent("\(fileName).xib").path
//        let outputPath = Folder.temporary.path
//        NibJect.ejectNib(at: filePath, to: outputPath)
//        let content = try File(path: "\(outputPath)/\(fileName).swift").readAsString()
//        let expected = "// MARK: - Child Views"
//        let subviewExpected = """
//            private lazy var childView: UIView = {
//        """
//        XCTAssertTrue(content.contains(expected))
//        XCTAssertTrue(content.contains(subviewExpected))
//    }
//
//    func testGeneratedSwiftSetupSubviews() throws {
//        let fileName = "SimpleView"
//        let filePath = URL.resources.appendingPathComponent("\(fileName).xib").path
//        let outputPath = Folder.temporary.path
//        NibJect.ejectNib(at: filePath, to: outputPath)
//        let content = try File(path: "\(outputPath)/\(fileName).swift").readAsString()
//        let expected = """
//            private func setupSubviews() {
//                addSubview(childView)
//
//                var constraints: [NSLayoutConstraint] = []
//
//                constraints.append(contentsOf: layoutChildView())
//                NSLayoutConstraint.activate(constraints)
//            }
//        """
//        XCTAssertTrue(content.contains(expected))
//    }

}
