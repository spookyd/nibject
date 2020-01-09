//
//  IBTool.swift
//  
//
//  Created by Luke Davis on 11/25/19.
//

import Foundation

public struct IBTool {
    public enum Argument {
        case objects
        case hierarchy
        case connections
        case classes

        var commandlineValue: String {
            switch self {
            case .objects: return "--objects"
            case .hierarchy: return "--hierarchy"
            case .connections: return "--connections"
            case .classes: return "--classes"
            }
        }
    }

    var path = "/usr/bin/ibtool"

    public init() {}

    public func run(_ filePath: String, _ arguments: [Argument]) -> Result<Data, Error> {
        let process = Process()
        var processArguments = [filePath]
        processArguments.append(contentsOf: arguments.map({ $0.commandlineValue }))
        process.launchPath = path
        process.arguments = processArguments

        let pipe = Pipe()
        process.standardOutput = pipe

        do {
            if #available(OSX 10.13, *) {
                try process.run()
            } else {
                process.launch()
            }

            let data = pipe.fileHandleForReading.readDataToEndOfFile()

            return .success(data)
        } catch {
            return .failure(error)
        }
    }

}

public struct BashRunner {

    public func run(_ cmd: String) -> String? {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", cmd]

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)

        return output
    }

}
