@testable import CodeWriter
import XCTest

final class SelfExpressionTests: XCTestCase {

    func testSelfInitializer() {
        let selfProp = SelfExpression(memberName: "prop")
        let initializer = InitializerExpression { builder in
            builder.isExplicit(false)
            builder.initializingExpression(RawExpression(rawValue: "Frog"))
            builder.addArgument(name: "t", value: "\"test\"")
        }
        let actual = AssignmentOperatorExpression(expression: selfProp, value: initializer)
        let expected = "self.prop = Frog(t: \"test\")"
        XCTAssertEqual(actual.outputText, expected)
    }

    func testVariableAssignment() {
        let initializer = InitializerExpression { builder in
            builder.isExplicit(false)
            builder.initializingExpression(RawExpression(rawValue: "Frog"))
            builder.addArgument(name: "t", value: "\"test\"")
        }
        let actual = VariableDeclaration { builder in
            builder.setName("prop")
            builder.expression(initializer)
        }
        let expected = "var prop = Frog(t: \"test\")"
        XCTAssertEqual(actual.outputText, expected)
    }

    func testLazyPropWithClosure() {
        let closure = ClosureExpression { builder in
            let propertyName = "a"
            let constant = ConstantDeclaration { builder in
                builder.setName(propertyName)
                builder.expression(InitializerExpression { builder in
                    builder.initializingExpression(RawExpression(rawValue: "SomeClass"))
                })
            }
            let returnValue = ReturnExpression(expression: RawExpression(rawValue: propertyName))
            builder.bodyStatements([
                constant,
                returnValue
            ])
        }
        let executed = InitializerExpression { builder in
            builder.initializingExpression(closure)
        }
        let actual = VariableDeclaration { builder in
            builder.accessLevel(.private)
            builder.isLazy(true)
            builder.setName("someClass")
            builder.explicitType("SomeClass")
            builder.expression(executed)
        }.outputText
        let expected = """
        private lazy var someClass: SomeClass = {
            let a = SomeClass()
            return a
        }()
        """
        XCTAssertEqual(actual, expected)
    }
}
