//
//  Shell.swift
//
//
//  Created by Kamaal M Farah on 27/07/2023.
//

#if os(macOS)
    import Foundation

    /// A utility for executing shell commands on macOS systems.
    ///
    /// The `Shell` struct provides convenient methods to run shell commands using various shells
    /// like `/bin/zsh` or `/bin/bash`. It supports execution in different directories and with
    /// custom environment variables.
    ///
    /// # Availability
    /// This utility is only available on macOS systems due to its reliance on macOS-specific
    /// shell environments and the `Process` class behavior.
    ///
    /// # Example Usage
    /// ```swift
    /// // Basic command execution
    /// let result = Shell.zsh("ls -la")
    ///
    /// // Command with custom environment variables
    /// let envResult = Shell.zsh("echo $MY_VAR", withEnvironmentVariables: ["MY_VAR": "Hello"])
    ///
    /// // Command executed in a specific directory
    /// let dirResult = Shell.zsh("pwd", at: "/Users/username/Documents")
    /// ```
    public struct Shell {
        /// Private initializer to prevent instantiation.
        ///
        /// The `Shell` struct is designed to be used as a namespace for static utility methods.
        /// All functionality is accessed through static methods like `zsh(_:)` and `shell(_:_:)`.
        private init() {}

        /// Executes a command using `/bin/zsh` and returns the standard output or an error.
        /// - Parameters:
        ///   - command: The shell command to run.
        ///   - executionLocation: Optional working directory to `cd` into before executing.
        ///   - environmentVariables: Dictionary of environment variables to set for the command execution.
        /// - Returns: `.success(stdout)` when the command succeeds, or `.failure` when an error occurs.
        ///
        /// # Example
        /// ```swift
        /// let result = Shell.zsh("echo hello")
        /// if case let .success(output) = result { print(output) }
        ///
        /// // With environment variables
        /// let envResult = Shell.zsh("echo $MY_VAR", withEnvironmentVariables: ["MY_VAR": "Hello World"])
        /// ```
        public static func zsh(
            _ command: String,
            at executionLocation: String? = nil,
            withEnvironmentVariables environmentVariables: [String: String] = [:]
        ) -> Result<String, Errors> {
            self.shell(
                "/bin/zsh", command, at: executionLocation,
                withEnvironmentVariables: environmentVariables)
        }

        /// Executes a command using the provided shell path and returns the standard output or an error.
        /// - Parameters:
        ///   - launchPath: Absolute path to a shell executable (e.g., `/bin/zsh`, `/bin/bash`).
        ///   - command: The command to run.
        ///   - executionLocation: Optional working directory to `cd` into before executing.
        ///   - environmentVariables: Dictionary of environment variables to set for the command execution.
        /// - Returns: `.success(stdout)` when the command succeeds, or `.failure` when an error occurs.
        ///
        /// # Example
        /// ```swift
        /// let result = Shell.shell("/bin/zsh", "echo $HOME")
        ///
        /// // With custom environment variables
        /// let envResult = Shell.shell("/bin/bash", "echo $CUSTOM_VAR",
        ///                            withEnvironmentVariables: ["CUSTOM_VAR": "custom_value"])
        /// ```
        public static func shell(
            _ launchPath: String,
            _ command: String,
            at executionLocation: String? = nil,
            withEnvironmentVariables environmentVariables: [String: String] = [:]
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

            task.environment = environmentVariables
            task.standardOutput = outputPipe
            task.standardError = errorPipe
            task.arguments = ["-c", commandToUse]
            task.executableURL = URL(fileURLWithPath: launchPath)
            task.launch()

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
            if let outputData, let outputString = String(data: outputData, encoding: .utf8) {
                return .success(outputString)
            }

            let errorData: Data?
            do {
                errorData = try errorPipe.fileHandleForReading.readToEnd()
            } catch {
                return .failure(.readPipeError(context: error, pipe: .error))
            }
            if let errorData, let errorString = String(data: errorData, encoding: .utf8) {
                return .failure(.standardError(message: errorString))
            }

            // No output
            return .success("")

        }
    }

    extension Shell {
        /// Represents the different types of errors that can occur during shell command execution.
        ///
        /// This error type provides detailed information about what went wrong during command execution,
        /// including standard error output and pipe reading failures.
        public enum Errors: Error {
            /// An error occurred and was written to the standard error stream.
            /// - Parameter message: The error message from the command's stderr output.
            case standardError(message: String)

            /// An error occurred while reading from output or error pipes.
            /// - Parameters:
            ///   - context: The underlying error that caused the pipe reading failure.
            ///   - pipe: Specifies whether the error occurred on the output or error pipe.
            case readPipeError(context: Error, pipe: PipeTypes)
        }

        /// Specifies the type of pipe where an error occurred during command execution.
        ///
        /// Used in conjunction with `readPipeError` to indicate whether the failure
        /// happened while reading from the standard output or standard error pipe.
        public enum PipeTypes: Sendable {
            /// Indicates an error occurred while reading from the standard output pipe.
            case output

            /// Indicates an error occurred while reading from the standard error pipe.
            case error
        }
    }

    /// Provides `Equatable` conformance for `Shell.Errors`.
    ///
    /// This extension allows `Shell.Errors` instances to be compared for equality,
    /// which is useful for testing and error handling scenarios.
    ///
    /// # Equality Rules
    /// - Two `standardError` cases are equal if their messages are identical.
    /// - Two `readPipeError` cases are equal if they have the same pipe type and
    ///   their underlying error descriptions match.
    /// - Different error cases are never equal.
    extension Shell.Errors: Equatable {
        /// Compares two `Shell.Errors` instances for equality.
        /// - Parameters:
        ///   - lhs: The left-hand side error to compare.
        ///   - rhs: The right-hand side error to compare.
        /// - Returns: `true` if the errors are considered equal, `false` otherwise.
        public static func == (lhs: Shell.Errors, rhs: Shell.Errors) -> Bool {
            if case let .readPipeError(leftContext, leftPipe) = lhs,
                case let .readPipeError(rightContext, rightPipe) = rhs
            {
                return leftPipe == rightPipe
                    && leftContext.localizedDescription == rightContext.localizedDescription
            }

            if case let .standardError(leftMessage) = lhs,
                case let .standardError(rightMessage) = rhs
            {
                return leftMessage == rightMessage
            }

            return false
        }
    }
#endif
