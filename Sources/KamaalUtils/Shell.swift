//
//  Shell.swift
//
//
//  Created by Kamaal M Farah on 27/07/2023.
//

#if os(macOS)
import Foundation

public struct Shell {
    private init() { }

    public static func zsh(_ command: String) -> Result<String, Errors> {
        shell("/bin/zsh", command)
    }

    public static func shell(_ launchPath: String, _ command: String) -> Result<String, Errors> {
        let task = Process()
        let outputPipe = Pipe()
        let errorPipe = Pipe()

        task.standardOutput = outputPipe
        task.standardError = errorPipe
        task.arguments = ["-c", command]
        task.launchPath = launchPath
        task.launch()

        let errorData: Data?
        do {
            errorData = try errorPipe.fileHandleForReading.readToEnd()
        } catch {
            return .failure(.readPipeError(context: error, pipe: .error))
        }
        if let errorData, let errorString = String(data: errorData, encoding: .utf8) {
            return .failure(.standardError(message: errorString))
        }

        let outputData: Data?
        do {
            outputData = try outputPipe.fileHandleForReading.readToEnd()
        } catch {
            return .failure(.readPipeError(context: error, pipe: .output))
        }

        guard let outputData else { return .success("") }

        return .success(String(data: outputData, encoding: .utf8) ?? "")
    }
}

extension Shell {
    public enum Errors: Error {
        case standardError(message: String)
        case readPipeError(context: Error, pipe: PipeTypes)
    }

    public enum PipeTypes {
        case output
        case error
    }
}

extension Shell.Errors: Equatable {
    public static func == (lhs: Shell.Errors, rhs: Shell.Errors) -> Bool {
        if case let .readPipeError(leftContext, leftPipe) = lhs,
           case let .readPipeError(rightContext, rightPipe) = rhs {
            return leftPipe == rightPipe && leftContext.localizedDescription == rightContext.localizedDescription
        }

        if case let .standardError(leftMessage) = lhs, case let .standardError(rightMessage) = rhs {
            return leftMessage == rightMessage
        }

        return false
    }
}
#endif
