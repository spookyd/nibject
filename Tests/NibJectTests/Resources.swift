//
//  File.swift
//  
//
//  Created by Luke Davis on 11/29/19.
//

import Foundation

extension URL {
    static let resources: URL = {
        let thisSourceFile = URL(fileURLWithPath: #file)
        let thisDirectory = thisSourceFile.deletingLastPathComponent()
        return thisDirectory.appendingPathComponent("../Resources")
    }()
}
