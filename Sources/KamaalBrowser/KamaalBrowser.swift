//
//  KamaalBrowser.swift
//
//
//  Created by Kamaal M Farah on 22/04/2023.
//

import SwiftUI
import SafariServices

extension View {
    /// On iOS opens the given `URL` in a in app browser when `isPresented` state is set to true and on macOS opens
    /// your default browser with the given `URL`.
    /// - Parameters:
    ///   - isPresented: Whether to open the browser or not.
    ///   - url: The url to open in the browser.
    ///   - color: The accent color on the browser buttons.
    /// - Returns: The modified view.
    ///
    /// Basic usage example:
    ///
    /// ```swift
    /// import SwiftUI
    /// import KamaalBrowser
    ///
    /// struct ContentView: View {
    ///     @State private var showInAppBrowser = false
    ///
    ///     var body: some View {
    ///         Button(action: { showInAppBrowser = true }) {
    ///             Text("Open browser")
    ///         }
    ///         .kBrowser(isPresented: $showInAppBrowser, url: URL(string: "https://kamaal.io")!)
    ///     }
    /// }
    /// ```
    @available(macOS 11.0, *)
    public func kBrowser(isPresented: Binding<Bool>, url: URL, color: Color = .accentColor) -> some View {
        modifier(InAppBrowserSUI(
            isPresented: isPresented,
            url: .constant(url),
            fallbackURL: url,
            color: color,
            bindingWithURL: false,
        ))
    }

    /// On iOS opens the given `URL` in a in app browser when `isPresented` state is set to true and on macOS opens
    /// your default browser with the given `URL`.
    /// - Parameters:
    ///   - url: The url to show. If this url is not nil than the browser opens.
    ///   - fallbackURL: A valid url in case the url given is invalid.
    ///   - color: The accent color on the browser buttons.
    /// - Returns: The modified view.
    ///
    /// Basic usage example:
    ///
    /// ```swift
    /// import SwiftUI
    /// import KamaalBrowser
    ///
    /// struct ContentView: View {
    ///     @State private var urlToShowInBrowser: URL?
    ///
    ///     var body: some View {
    ///         Button(action: { urlToShowInBrowser = URL(string: "https://kamaal.io") }) {
    ///             Text("Open browser")
    ///         }
    ///         .kBrowser($urlToShowInBrowser, fallbackURL: URL(string: "https://kamaal.io")!)
    ///     }
    /// }
    /// ```
    @available(macOS 11.0, *)
    public func kBrowser(_ url: Binding<URL?>, fallbackURL: URL, color: Color = .accentColor) -> some View {
        modifier(InAppBrowserSUI(
            isPresented: .constant(url.wrappedValue != nil),
            url: url,
            fallbackURL: fallbackURL,
            color: color,
            bindingWithURL: true,
        ))
    }
}

@available(macOS 11.0, *)
private struct InAppBrowserSUI: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var url: URL?

    let fallbackURL: URL
    let color: Color
    let bindingWithURL: Bool

    func body(content: Content) -> some View {
        content
        #if canImport(UIKit)
        .sheet(isPresented: self.$isPresented, onDismiss: {
            if self.bindingWithURL {
                self.url = nil
            }
        }) {
            InAppBrowserRepresentable(url: self.url ?? self.fallbackURL, tintColor: self.color)
        }
        #else
        .onChange(of: self.isPresented, perform: { newValue in
                if !self.bindingWithURL, newValue, let url {
                    NSWorkspace.shared.open(url)
                    self.isPresented = false
                }
            })
            .onChange(of: self.url, perform: { newValue in
                if self.bindingWithURL, let url = newValue {
                    NSWorkspace.shared.open(url)
                    self.url = nil
                }
            })
        #endif
    }
}

#if canImport(UIKit)
fileprivate struct InAppBrowserRepresentable: UIViewControllerRepresentable {
    let url: URL
    let tintColor: Color

    func makeUIViewController(context _: Context) -> UIViewControllerType {
        let configuaration = SFSafariViewController.Configuration()
        let safariViewController = SFSafariViewController(url: url, configuration: configuaration)
        safariViewController.dismissButtonStyle = .close
        safariViewController.preferredBarTintColor = .systemBackground
        safariViewController.preferredControlTintColor = UIColor(self.tintColor)
        return safariViewController
    }

    func updateUIViewController(_: UIViewControllerType, context _: Context) { }

    typealias UIViewControllerType = SFSafariViewController
}

#if DEBUG
struct InAppBrowserRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        InAppBrowserRepresentable(url: URL(string: "https://kamaal.io")!, tintColor: .red)
    }
}
#endif
#endif
