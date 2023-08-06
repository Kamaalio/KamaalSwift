//
//  FileManager.swift
//
//
//  Created by Kamaal Farah on 06/08/2023.
//

import Foundation

extension FileManager {
    /// Find directory or file by directoryname or filename.
    /// - Parameters:
    ///   - directory: The directory to search in.
    ///   - searchPath: The directoryname or filename to find.
    /// - Returns: The directory or file that has been found or nil if no directory or file has been found.
    public func findDirectoryOrFile(inDirectory directory: URL, searchPath: String) throws -> URL? {
        try contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [])
            .find(by: \.lastPathComponent, is: searchPath)
    }

    /// Filter directories or files by directoryname or filename.
    /// - Parameters:
    ///   - directory: The directory to search in.
    ///   - searchPath: The directoryname or filename to filter on.
    /// - Returns: The directories or files that have been found.
    public func filterDirectoryOrFile(inDirectory directory: URL, searchPath: String) throws -> [URL] {
        try contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: [])
            .filter { fileOrDirectory in fileOrDirectory.lastPathComponent == searchPath }
    }
}
