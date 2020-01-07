//
//  CommandRegistry.swift
//  
//
//  Created by Luke Davis on 1/2/20.
//

import Foundation
import NibJectKit
import TSCBasic
import TSCUtility

protocol Command {
    var command: String { get }
    var overview: String { get }

    init(parser: ArgumentParser, optionsBinder: ArgumentBinder<NibjectOptions>)
    func run(with options: NibjectOptions) throws
}

struct CommandRegistry {

    private let parser: ArgumentParser
    private let optionBinder: ArgumentBinder<NibjectOptions>
    private var options = NibjectOptions()
    private var mainCommand: Command? = .none
    private var commands: [Command] = []
    
    init(usage: String, overview: String) {
        self.parser = ArgumentParser(usage: usage, overview: overview)
        self.optionBinder = ArgumentBinder<NibjectOptions>()
    }

    mutating func register(command: Command.Type) {
        commands.append(command.init(parser: parser, optionsBinder: optionBinder))
    }
    
    mutating func main(_ command: Command.Type) {
        mainCommand = command.init(parser: parser, optionsBinder: optionBinder)
    }

    mutating func run(_ commandlineArguments: [String]) {
        do {
            let parsedArguments = try parse(commandlineArguments)
            try process(arguments: parsedArguments)
        } catch let error as ArgumentParserError {
            guard case ArgumentParserError.expectedArguments(let parser, _) = error else {
                print(error.description)
                exit(1)
            }
            print(error.description)
            parser.printUsage(on: stderrStream)
        } catch let error as NibjectError {
            print(error.localizedDescription)
        } catch {
            print(error.localizedDescription)
        }
    }

    private func parse(_ commandlineArguments: [String]) throws -> ArgumentParser.Result {
        return try parser.parse(commandlineArguments)
    }

    private mutating func process(arguments: ArgumentParser.Result) throws {
        guard let subparser = arguments.subparser(parser),
            let command = commands.first(where: { $0.command == subparser }) else {
                guard let mainCommand = self.mainCommand else {
                parser.printUsage(on: stdoutStream)
                return
            }
            try run(command: mainCommand, with: arguments)
            return
        }
        try run(command: command, with: arguments)
    }
    
    private mutating func run(command: Command, with arguments: ArgumentParser.Result) throws {
        var options = NibjectOptions()
        try optionBinder.fill(parseResult: arguments, into: &options)
        self.options = options
        try command.run(with: options)
    }
}
