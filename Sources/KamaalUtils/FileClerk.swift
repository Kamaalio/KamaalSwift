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

    public static let libraryDirectory = fileManager.urls(for: .libraryDirectory, in: .userDomainMask).first

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

    public static func deleteItem(at url: URL) throws {
        try self.fileManager.removeItem(at: url)
    }

    public static func getOrCreateDirectory(at url: URL) throws -> URL {
        guard !self.fileManager.fileExists(atPath: url.path) else { return url }

        try self.fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        return url
    }

    public static func createFile(with data: Data, at url: URL) {
        self.fileManager.createFile(atPath: url.path, contents: data)
    }

    @available(macOS 13.0, iOS 16.0, watchOS 9.0, *)
    public static func getOrCreateSubfolder(atBase baseURL: URL, subFolderPaths: [String]) throws -> URL {
        var currentPath = baseURL
        for subFolderPath in subFolderPaths {
            currentPath = try self.getOrCreateDirectory(at: currentPath.appending(path: subFolderPath))
        }
        return currentPath
    }
}
