//
//  String.swift
//  
//
//  Created by Luke Davis on 12/1/19.
//

import Foundation

extension StringProtocol {

    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }

    var upperCamelCased: String {
        return self
            .split(separator: " ")
            .map { return $0.capitalizingFirstLetter() }
            .joined()
    }

    var lowerCamelCased: String {
        let upperCased = self.upperCamelCased
        return upperCased.prefix(1).lowercased() + upperCased.dropFirst()
    }
}
