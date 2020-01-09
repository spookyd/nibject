import XCTest
@testable import CodeWriter

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
