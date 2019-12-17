import Files
import XCTest
@testable import NibJect

final class ConstraintTests: XCTestCase {

    func testGeneratedSwiftContainsSubviews() throws {
        let fileName = "SimpleView"
        let filePath = URL.resources.appendingPathComponent("\(fileName).xib").path
        let outputPath = Folder.temporary.path
        let expected = try File(path: URL.resources.appendingPathComponent("\(fileName).swift").path).readAsString()
        NibJect.ejectNib(at: filePath, to: outputPath)
        let actual = try File(path: "\(outputPath)/\(fileName).swift").readAsString()
        XCTAssertEqual(actual, expected)
    }

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
