//
//  KMailView.swift
//  KamaalUI
//
//  Created by Kamaal Farah on 06/05/2020.
//

import SwiftUI
#if !os(macOS)
import MessageUI
#endif

#if !os(macOS)
public struct KMailView: UIViewControllerRepresentable {
    @Binding public var isShowing: Bool
    @Binding public var result: Result<MFMailComposeResult, Error>?

    public var emailAddress: String
    public var emailSubject: String

    public init(
        isShowing: Binding<Bool>,
        result: Binding<Result<MFMailComposeResult, Error>?>,
        emailAddress: String,
        emailSubject: String
    ) {
        self._isShowing = isShowing
        self._result = result
        self.emailAddress = emailAddress
        self.emailSubject = emailSubject
    }

    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding public var isShowing: Bool
        @Binding public var result: Result<MFMailComposeResult, Error>?

        public init(isShowing: Binding<Bool>,
                    result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }

        public func mailComposeController(
            _: MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?
        ) {
            defer {
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(isShowing: $isShowing, result: $result)
    }

    public func makeUIViewController(context: UIViewControllerRepresentableContext<KMailView>)
        -> MFMailComposeViewController {
        let viewController = MFMailComposeViewController()
        viewController.mailComposeDelegate = context.coordinator
        viewController.setToRecipients([emailAddress])
        viewController.setSubject(emailSubject)
        return viewController
    }

    public func updateUIViewController(
        _: MFMailComposeViewController,
        context _: UIViewControllerRepresentableContext<KMailView>
    ) { }
}
#endif
