//
//  SavePanel.swift
//
//
//  Created by Kamaal M Farah on 27/07/2023.
//

#if os(macOS)
import Cocoa

public struct SavePanel {
    private init() { }

    public enum Errors: Error {
        case canceled
        case unknown(response: NSApplication.ModalResponse)
    }

    @MainActor
    public static func save(filename: String) async -> Result<NSSavePanel, Errors> {
        await withCheckedContinuation { continuation in
            self.save(filename: filename) { result in
                continuation.resume(returning: result)
            }
        }
    }

    @MainActor
    private static func save(
        filename: String,
        beginHandler: @escaping (Result<NSSavePanel, Errors>) -> Void,
    ) {
        let panel = NSSavePanel()
        panel.canCreateDirectories = true
        panel.showsTagField = true
        panel.nameFieldStringValue = filename
        panel.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.modalPanelWindow)))
        panel.begin(completionHandler: { result in
            switch result {
            case .cancel, .continue, .stop:
                beginHandler(.failure(.canceled))
            case .OK:
                beginHandler(.success(panel))
            default:
                beginHandler(.failure(.unknown(response: result)))
            }
        })
    }
}
#endif
