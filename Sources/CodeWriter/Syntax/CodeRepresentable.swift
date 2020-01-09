import Foundation

public protocol CodeRepresentable: Buildable, CustomStringConvertible {
    var outputText: String { get }
}

public extension CodeRepresentable {
    var description: String {
        return outputText
    }
}
