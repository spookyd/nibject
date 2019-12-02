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
        let content = try File(path: "\(outputPath)/\(fileName).swift").readAsString()
        let expectedTitle = "//  \(fileName).swift"
        let expectedAccreditation = "//  Created using NibJect by Luke Davis"
        XCTAssertTrue(content.contains(expectedTitle))
        XCTAssertTrue(content.contains(expectedAccreditation))
    }
    
    func testGeneratedSwiftFileContainsTopLevelClass() throws {
        let fileName = "SimpleView"
        let filePath = URL.resources.appendingPathComponent("\(fileName).xib").path
        let outputPath = Folder.temporary.path
        NibJect.ejectNib(at: filePath, to: outputPath)
        let content = try File(path: "\(outputPath)/\(fileName).swift").readAsString()
        let expectedClassDeclaration = "public class \(fileName): UIView {"
        XCTAssertTrue(content.contains(expectedClassDeclaration))
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
