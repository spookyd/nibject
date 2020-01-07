//
//  NibjectError.swift
//  
//
//  Created by Luke Davis on 1/5/20.
//

import Foundation

public enum NibjectError: Error {
    
    public enum InterfaceBuilderParsingFailureReason {
        case ibtoolInputFailure(errorMessages: [String])
        case ibtoolFailure(underlyingError: Error)
        case deserializationFailure(underlyingError: Error)
    }
    
    public enum ViewGraphBuilderFailureReason {
        case noTopLevelView
        case objectLookupFailure(underlyingError: IBUIViewError)
    }
    
    case interfaceBuilderParsingError(reason: InterfaceBuilderParsingFailureReason)
    case viewGraphBuilderError(reason: ViewGraphBuilderFailureReason)
    case unknownError(underlyingError: Error)
    
    public var localizedDescription: String {
        switch self {
        case .interfaceBuilderParsingError(let reason): return reason.localizedDescription
        case .viewGraphBuilderError(let reason): return reason.localizedDescription
        case .unknownError(let underlyingError): return underlyingError.localizedDescription
        }
    }
}

// MARK: - InterfaceBuilderParsingFailureReason

extension NibjectError.InterfaceBuilderParsingFailureReason {
    var localizedDescription: String {
        switch self {
        case .ibtoolInputFailure(let errorMessages):
            return "IBTool failed while reading the file with the following errors:\(errorMessages.joined(separator: ", "))"
        case .ibtoolFailure(let underlyingError):
            return "IBTool failed with the following error:\n\(underlyingError.localizedDescription)"
        case .deserializationFailure(let underlyingError):
            return "Failed to parse Interface Builder plist because \(underlyingError.localizedDescription)"
        }
    }
}

// MARK: - ViewGraphBuilderFailureReason

extension NibjectError.ViewGraphBuilderFailureReason {
    var localizedDescription: String {
        switch self {
        case .noTopLevelView:
            return "No top level view found. The .xib file must have at least one view"
        case .objectLookupFailure(let underlyingError):
            // TODO: Add issue link.
            // Add additional steps and things to include like the print out of the IBTool for the xib file
            return "Failed to locate an expected object. This is likely bug. Please report. \(underlyingError.localizedDescription)"
        }
    }
}

// MARK: - IBUIViewError

extension IBUIViewError {
    func asNibjectError() -> NibjectError {
        switch self {
        case .noTopLevelViewInHierarchy:
            return .viewGraphBuilderError(reason: .noTopLevelView)
        case .objectNotFound:
            return .viewGraphBuilderError(reason: .objectLookupFailure(underlyingError: self))
        }
    }
}
