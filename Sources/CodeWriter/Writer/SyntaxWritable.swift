import Foundation

public struct Syntax {
    public static let newline = "\n"
    public static let tab = "\t"
    public static let space = " "
}

public struct WritingContext {
    public enum Indentation {
        case tab
        case space(count: Int)
    }
    public var indentationLevel: Int = 0
    public var indentation: Indentation = .space(count: 4)
    public init() {}
    public var outputIndentation: String {
        switch indentation {
        case .tab: return String(repeating: Syntax.tab, count: indentationLevel)
        case .space(let count): return String(repeating: " ", count: indentationLevel * count)
        }
    }
}

public protocol Buildable {
    func build(within context: WritingContext) -> String
}
