//
//  NibJectCommand.swift
//  
//
//  Created by Luke Davis on 1/3/20.
//

import Foundation
import NibJectKit
import TSCBasic
import TSCUtility

struct NibJectCommand: Command {

    let command: String = "eject"
    let overview: String = "Convert a .xib file into a generated Swift code"

    init(parser: ArgumentParser, optionsBinder: ArgumentBinder<NibjectOptions>) {
        let filePath = parser.add(positional: "input",
                                  kind: String.self,
                                  optional: false,
                                  usage: "-input <xibFilePath>",
                                  completion: .filename)
        optionsBinder.bind(positional: filePath, to: { $0.inputFilePath = $1 })
        let outFilePath = parser.add(option: "-output",
                                     shortName: "--o",
                                     kind: String.self,
                                     usage: "-output <swiftFilePath>",
                                     completion: ShellCompletion.none)
        optionsBinder.bind(option: outFilePath, to: { $0.outputFilePath = $1 })
    }

    func run(with options: NibjectOptions) throws {
        guard let filePath = options.inputFilePath else {
            return
        }
        let inputPath = filePath
        let outputPath: String
        if let output = options.outputFilePath {
            outputPath = output
        } else {
            if let workingDir = localFileSystem.currentWorkingDirectory {
                outputPath = workingDir.pathString
            } else {
                outputPath = "."
            }
        }
        print("Ejecting xib \(inputPath)")
        let data = try NibJect.ejectNib(at: inputPath, to: outputPath).get()
        print("Ejected \(data.fileName) to \(outputPath)")
    }

}
