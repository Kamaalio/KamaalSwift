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

    public static func zsh(_ command: String, at executionLocation: String? = nil) -> Result<String, Errors> {
        self.shell("/bin/zsh", command, at: executionLocation)
    }

    public static func shell(
        _ launchPath: String,
        _ command: String,
        at executionLocation: String? = nil
    ) -> Result<String, Errors> {
        let commandToUse: String
        var previousPath: String?
        if let executionLocation {
            let previousPathResult = self.shell(launchPath, "pwd")
            switch previousPathResult {
            case .failure: return previousPathResult
            case let .success(success): previousPath = success
            }
            commandToUse = "cd \(executionLocation) && \(command)"
        } else {
            commandToUse = command
        }

        let task = Process()
        let outputPipe = Pipe()
        let errorPipe = Pipe()

        task.standardOutput = outputPipe
        task.standardError = errorPipe
        task.arguments = ["-c", commandToUse]
        task.executableURL = URL(fileURLWithPath: launchPath)
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

        if let previousPath {
            let backToOriginalPathResult = self.shell(launchPath, "cd \(previousPath)")
            switch backToOriginalPathResult {
            case .failure: return backToOriginalPathResult
            case .success: break
            }
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

    public enum PipeTypes: Sendable {
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
