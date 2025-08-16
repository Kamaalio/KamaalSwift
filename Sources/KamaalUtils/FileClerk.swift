//
//  FileClerk.swift
//
//
//  Created by Kamaal M Farah on 06/01/2024.
//

import Foundation

public struct FileClerk {
    private nonisolated(unsafe) static let fileManager = FileManager.default

    private init() { }

    /// The user's Library directory URL, if available.
    public static let libraryDirectory = fileManager.urls(
        for: .libraryDirectory, in: .userDomainMask,
    ).first

    /// Moves all items from `sourceFolder` into `destinationFolder` without overwriting existing files.
    /// - Parameters:
    ///   - sourceFolder: Folder whose immediate contents will be moved.
    ///   - destinationFolder: Destination folder to move the contents to.
    /// - Throws: Errors from `FileManager` when moving items fails.
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, *)
    public static func moveFolderContent(from sourceFolder: URL, to destinationFolder: URL) throws {
        let sourceFolderContent = try fileManager.contentsOfDirectory(
            at: sourceFolder,
            includingPropertiesForKeys: nil,
            options: [],
        )
        for content in sourceFolderContent {
            let destinationURL = destinationFolder.appending(path: content.lastPathComponent)
            guard !self.fileManager.fileExists(atPath: destinationURL.path) else { continue }

            try self.fileManager.moveItem(at: content, to: destinationURL)
        }
    }

    /// Deletes the file or directory at the provided URL.
    /// - Parameter url: The item to delete.
    /// - Throws: Errors from `FileManager` if removal fails.
    public static func deleteItem(at url: URL) throws {
        try self.fileManager.removeItem(at: url)
    }

    /// Ensures a directory exists at the provided URL, creating it if needed.
    /// - Parameter url: Directory URL.
    /// - Returns: The provided URL.
    /// - Throws: Errors from `FileManager` when creating the directory.
    public static func getOrCreateDirectory(at url: URL) throws -> URL {
        guard !self.fileManager.fileExists(atPath: url.path) else { return url }

        try self.fileManager.createDirectory(
            at: url, withIntermediateDirectories: true, attributes: nil,
        )
        return url
    }

    /// Creates or overwrites a file at the given URL with the provided data.
    /// - Parameters:
    ///   - data: File contents.
    ///   - url: Destination file URL.
    public static func createFile(with data: Data, at url: URL) {
        self.fileManager.createFile(atPath: url.path, contents: data)
    }

    /// Ensures a nested subfolder path exists relative to `baseURL`, creating missing folders.
    /// - Parameters:
    ///   - baseURL: Base path to start from.
    ///   - subFolderPaths: Path components in order.
    /// - Returns: The final subfolder URL.
    /// - Throws: Errors when creating intermediate directories.
    @available(macOS 13.0, iOS 16.0, watchOS 9.0, *)
    public static func getOrCreateSubfolder(atBase baseURL: URL, subFolderPaths: [String]) throws
        -> URL {
        var currentPath = baseURL
        for subFolderPath in subFolderPaths {
            currentPath = try self.getOrCreateDirectory(
                at: currentPath.appending(path: subFolderPath),
            )
        }
        return currentPath
    }
}
