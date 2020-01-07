import XCTest
@testable import NibJectKit

final class NameFormattingTests: XCTestCase {
    func testLowerCamelCased() {
        let actual = "String to test".lowerCamelCased
        let expected = "stringToTest"
        XCTAssertEqual(actual, expected)
    }
    
    func testLowerCamelCased_withUppercaseInString() {
        let actual = "String to TEST".lowerCamelCased
        let expected = "stringToTEST"
        XCTAssertEqual(actual, expected)
    }
    
    func testLowerCamelCased_withMixedCase() {
        let actual = "STRING with MiXeD cAsE".lowerCamelCased
        let expected = "sTRINGWithMiXeDCAsE"
        XCTAssertEqual(actual, expected)
    }
}
