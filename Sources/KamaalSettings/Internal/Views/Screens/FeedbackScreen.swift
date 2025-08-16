//
//  FeedbackScreen.swift
//
//
//  Created by Kamaal M Farah on 20/12/2022.
//

import SwiftUI
import KamaalUI
import KamaalPopUp
import KamaalLogger
import KamaalExtensions
import KamaalNavigation
import KamaalAPIServices

private let logger = KamaalLogger(label: "FeedbackScreen")

struct FeedbackScreen<ScreenType: NavigatorStackValue>: View {
    @Environment(\.settingsConfiguration) private var settingsConfiguration: SettingsConfiguration
    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    @EnvironmentObject private var navigator: Navigator<ScreenType>

    @ObservedObject private var viewModel: ViewModel

    init(style: FeedbackStyles, description: String = "") {
        self._viewModel = ObservedObject(wrappedValue: ViewModel(style: style, description: description))
    }

    var body: some View {
        VStack {
            KFloatingTextField(
                text: self.$viewModel.title,
                title: "Title".localized(comment: ""),
            )
            KTextView(
                text: self.$viewModel.description,
                title: "Description".localized(comment: ""),
            )
            AppButton(action: self.onSendPress) {
                AppText(localizedString: "Send", comment: "")
                    .font(.headline)
                    .bold()
                    .foregroundColor(self.colorScheme == .dark ? .black : .white)
                    .padding(.vertical, .extraSmall)
                    .ktakeWidthEagerly()
                    .background(Color.accentColor)
                    .cornerRadius(.small)
            }
            .disabled(self.viewModel.disableSubmit)
        }
        .padding(.all, .medium)
        .kPopUpLite(isPresented: self.$viewModel.showToast,
                    style: self.viewModel.lastToastType?.pupUpStyle ?? .bottom(
                        title: "",
                        type: .warning,
                        description: nil,
                    ),
                    backgroundColor: self.colorScheme == .dark ? .black : .white)
        .accentColor(self.settingsConfiguration.currentColor)
    }

    private func onSendPress() {
        Task {
            await self.viewModel.submit(using: self.settingsConfiguration.feedback, dismiss: {
                self.navigator.goBack()
            })
        }
    }
}

@MainActor
private final class ViewModel: ObservableObject {
    @Published var title = ""
    @Published var description: String
    @Published private(set) var loading = false
    @Published var showToast = false
    @Published private(set) var toastType: ToastType? {
        didSet { self.toastTypeDidSet() }
    }

    @Published private(set) var lastToastType: ToastType?
    private var toastTimer: Timer?

    let style: FeedbackStyles

    init(style: FeedbackStyles, description: String) {
        self.style = style
        self.description = description
    }

    enum ToastType: Equatable {
        case success
        case failure

        var pupUpStyle: KPopUpStyles {
            .bottom(title: self.title, type: self.popUpType, description: self.description)
        }

        private var title: String {
            switch self {
            case .failure:
                "Sorry, something went wrong".localized(comment: "")
            case .success:
                "Feedback sent".localized(comment: "")
            }
        }

        private var description: String? {
            switch self {
            case .failure:
                "Could not send feedback".localized(comment: "")
            case .success:
                nil
            }
        }

        private var popUpType: KPopUpBottomType {
            switch self {
            case .failure:
                .error
            case .success:
                .success
            }
        }
    }

    var disableSubmit: Bool {
        self.loading || self.title.trimmingByWhitespacesAndNewLines.isEmpty
    }

    func submit(
        using feedbackConfiguration: SettingsConfiguration.FeedbackConfiguration?,
        dismiss: @escaping () -> Void,
    ) async {
        guard let feedbackConfiguration else { return }

        let services = KamaalAPIServices()
        var gitHubAPI = services.gitHub
        gitHubAPI.configure(with: .init(token: feedbackConfiguration.token, username: feedbackConfiguration.username))

        await self.withLoading(completion: {
            let descriptionWithAdditionalFeedback = """
            # User Feedback

            \(description)

            # Additional Data

            \(feedbackConfiguration.additionalDataString ?? "{}")
            """
            do {
                _ = try await gitHubAPI.repos.createIssue(
                    username: feedbackConfiguration.username,
                    repoName: feedbackConfiguration.repoName,
                    title: self.title,
                    description: descriptionWithAdditionalFeedback,
                    assignee: feedbackConfiguration.username,
                    labels: feedbackConfiguration.additionalLabels.concat(self.style.labels),
                ).get()
            } catch {
                logger.error(label: "failed to send feedback", error: error)
                self.setToastType(to: .failure)
                return
            }

            logger.info("feedback sent")
            self.setToastType(to: .success)

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                dismiss()
            }
        })
    }

    @MainActor
    private func setToastType(to type: ToastType?) {
        self.toastType = type
        if type != nil {
            self.lastToastType = type
        }
    }

    @MainActor
    private func toastTypeDidSet() {
        if self.toastType != nil {
            if self.toastTimer != nil {
                self.toastTimer?.invalidate()
                self.toastTimer = nil
            }

            self.showToast = true
            self.toastTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] _ in
                Task.detached { @MainActor in
                    self?.handleToastTimerTick()
                }
            })
        } else {
            self.showToast = false
            self.toastTimer?.invalidate()
            self.toastTimer = nil
        }
    }

    private func handleToastTimerTick() {
        self.toastTimer?.invalidate()
        self.toastTimer = nil
        self.setToastType(to: .none)
    }

    private func withLoading<T: Sendable>(completion: () async -> T) async -> T {
        self.setLoading(true)
        let maybeResult = await completion()
        self.setLoading(false)
        return maybeResult
    }

    @MainActor
    private func setLoading(_ state: Bool) {
        self.loading = state
    }
}

// struct FeedbackScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        FeedbackScreen(style: .bug)
//    }
// }
