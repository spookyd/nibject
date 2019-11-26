import XCTest
@testable import NibJect

final class NibJectTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(NibJect().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
