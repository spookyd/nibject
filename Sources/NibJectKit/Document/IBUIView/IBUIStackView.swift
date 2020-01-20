//
//  IBUIStackView.swift
//  
//
//  Created by Luke Davis on 12/2/19.
//

import Foundation

public class IBUIStackView: IBUIView {
    
    public enum Axis: Int {
        case horizontal = 0
        case vertical = 1
    }
    
    public enum Distribution: Int {
        case fill = 0
        case fillEqually = 1
        case fillProportionally = 2
        case equalSpacing = 3
        case equalCentering = 4
    }
    
    public enum Alignment: Int {
        case fill = 0
        case leading = 1
        case center = 3
        case trailing = 4
    }
    
    public var axis: Axis {
        guard let rawValue = rawData.content["axis"] as? Int,
            let axis = Axis(rawValue: rawValue) else {
            return .horizontal
        }
        return axis
    }
    
    public var alignment: Alignment {
        guard let rawValue = rawData.content["alignment"] as? Int,
            let alignment = Alignment(rawValue: rawValue) else {
            return .fill
        }
        return alignment
    }
    
    public var baselineRelative: Bool {
        guard let rawValue = rawData.content["baselineRelativeArrangement"] as? Bool else { return false }
        return rawValue
    }
    
    public var distribution: Distribution {
        guard let rawValue = rawData.content["distribution"] as? Int,
            let distribution = Distribution(rawValue: rawValue) else {
                return .fill
        }
        return distribution
    }
    
    public var spacing: Float {
        guard let rawValue = rawData.content["spacing"] as? Float else {
                return 0
        }
        return rawValue
    }

    override func addSubviewMethodName() -> String {
        return "addArrangedSubview"
    }

}
