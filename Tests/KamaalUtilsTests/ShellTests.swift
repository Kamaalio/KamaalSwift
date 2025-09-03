//
//  ShellTests.swift
//
//
//  Created by Kamaal M Farah on 27/07/2023.
//

#if os(macOS)
    import Testing
    import Foundation
    import KamaalUtils
    import KamaalExtensions

    @Test("Echoes hello")
    func echoesHello() async throws {
        let result = try Shell.zsh("echo hello").get().splitLines.last

        #expect(result == "hello")
    }

    @Test("Fails on command not found")
    func failsOnCommandNotFound() async throws {
        let command = "ggggggggggg"

        #expect(
            throws: Shell.Errors.standardError(message: "zsh:1: command not found: \(command)\n")
        ) {
            try Shell.zsh(command).get()
        }
    }

    @Test("Environment variables with zsh")
    func environmentVariablesWithZsh() async throws {
        let testVar = "TEST_VALUE_12345"

        let result = try Shell.zsh(
            "echo $TEST_VAR", withEnvironmentVariables: ["TEST_VAR": testVar]
        ).get()
        let cleanedResult = result.trimmingByWhitespacesAndNewLines

        #expect(cleanedResult == testVar)
    }

    @Test("Environment variables with shell")
    func environmentVariablesWithShell() async throws {
        let testVar = "SHELL_TEST_VALUE_67890"

        let result = try Shell.shell(
            "/bin/zsh", "echo $SHELL_TEST_VAR",
            withEnvironmentVariables: ["SHELL_TEST_VAR": testVar]
        ).get()
        let cleanedResult = result.trimmingByWhitespacesAndNewLines

        #expect(cleanedResult == testVar)
    }

    @Test("Multiple environment variables")
    func multipleEnvironmentVariables() async throws {
        let envVars = [
            "VAR1": "value1",
            "VAR2": "value2",
            "VAR3": "value3",
        ]

        let result = try Shell.zsh("echo $VAR1-$VAR2-$VAR3", withEnvironmentVariables: envVars)
            .get()
        let cleanedResult = result.trimmingByWhitespacesAndNewLines

        #expect(cleanedResult == "value1-value2-value3")
    }

    @Test("Environment variables with execution location")
    func environmentVariablesWithExecutionLocation() throws {
        let testVar = "LOCATION_TEST_VALUE"
        let homeDir = NSHomeDirectory()

        let result = try Shell.zsh(
            "echo $LOCATION_VAR",
            at: homeDir,
            withEnvironmentVariables: ["LOCATION_VAR": testVar]
        ).get()
        let cleanedResult = result.trimmingByWhitespacesAndNewLines

        #expect(cleanedResult == testVar)
    }

    @Test("Environment variables")
    func environmentVariables() throws {
        let result = try Shell.zsh("echo hello", withEnvironmentVariables: [:]).get()
        let cleanedResult = result.trimmingCharacters(in: .whitespacesAndNewlines)

        #expect(cleanedResult == "hello")
    }
#endif
