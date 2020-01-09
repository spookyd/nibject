@testable import CodeWriter
import XCTest

final class ClassDeclarationTests: XCTestCase {
    func testSimpleClassDeclaration() {
        let actual = ClassDeclaration { builder in
            builder.setIdentifier("SimpleClass")
        }
        let expected = """
        class SimpleClass {
        }
        """
        XCTAssertEqual(actual.outputText, expected)
    }
}
