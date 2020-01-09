//
//  File.swift
//  
//
//  Created by Luke Davis on 12/24/19.
//

import Foundation
import NibJectKit

do {
    var registry = CommandRegistry(usage: "--input <filepath> [--output <filepath>]",
                                   overview: "Converts xib files into generated swift code")
    registry.main(NibJectCommand.self)

    registry.run(Array(CommandLine.arguments.dropFirst()))
}
