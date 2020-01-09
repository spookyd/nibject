import Foundation

public enum AccessLevel: CustomStringConvertible {
    case `open`
    case `public`
    case `internal`
    case `private`
    case `fileprivate`
    case `default`

    public var description: String {
        switch self {
        case .open: return "opem"
        case .public: return "public"
        case .internal: return "internal"
        case .private: return "private"
        case .fileprivate: return "fileprivate"
        case .default: return ""
        }
    }
}
