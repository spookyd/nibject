//
//  File.swift
//  
//
//  Created by Luke Davis on 12/24/19.
//

import Foundation
import SPMUtility
import NibJect

do {
    let parser = ArgumentParser(commandName: "nibject",
                                usage: "nibject",
                                overview: "Converts xib files into generated swift code",
                                seeAlso: "getopt(1)")
                                
    let input = parser.add(option: "--input",
                           shortName: "-i",
                           kind: String.self,
                           usage: "xib file to eject",
                           completion: .filename)
    let output = parser.add(option: "--output",
                            shortName: "-o",
                            kind: String.self,
                            usage: "Custom name of Swift file to eject",
                            completion: .filename)
    let argsv = Array(CommandLine.arguments.dropFirst())
    let parguments = try parser.parse(argsv)
    
    guard let fileName = parguments.get(input) else {
        fatalError("Invalid Output for File name")
    }
    
    guard let outputFileName = parguments.get(output) else {
        fatalError("Invalid Output for File name")
    }
    
    try NibJect.ejectNib(at: fileName, to: outputFileName).get()
    
} catch ArgumentParserError.expectedValue(let value) {
    print("Missing value for argument \(value).")
} catch ArgumentParserError.expectedArguments(let parser, let stringArray) {
    print("Parser: \(parser) Missing arguments: \(stringArray.joined()).")
} catch {
    print(error.localizedDescription)
}
