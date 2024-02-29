//
//  SupportAuthorScreen.swift
//
//
//  Created by Kamaal M Farah on 18/12/2022.
//

import SwiftUI
import KamaalUI
import KamaalPopUp
import KamaalLogger
import ConfettiSwiftUI
import KamaalNavigation

struct SupportAuthorScreen<ScreenType: NavigatorStackValue>: View {
    @EnvironmentObject private var navigator: Navigator<ScreenType>
    @EnvironmentObject private var store: Store

    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    @StateObject private var viewModel = ViewModel()

    var body: some View {
        ZStack {
            KScrollableForm {
                KJustStack {
                    if self.store.isLoading, !self.store.hasDonations {
                        KLoading()
                            .ktakeSizeEagerly()
                    }
                    ForEach(self.store.donations) { donation in
                        AppButton(action: { self.handlePurchase(donation) }) {
                            DonationView(donation: donation)
                        }
                        .padding(.vertical, .extraSmall)
                        .disabled(!self.store.canMakePayments)
                    }
                }
                .padding(.all, .medium)
            }
            if self.store.isLoading, !self.store.hasDonations {
                KLoading()
                    .ktakeSizeEagerly()
            }
            if self.store.isPurchasing {
                HStack {
                    KLoading()
                    AppText(localizedString: "Purchasing", comment: "")
                        .font(.headline)
                        .bold()
                }
                .ktakeSizeEagerly()
            }
        }
        .ktakeSizeEagerly(alignment: .topLeading)
        .onAppear(perform: self.handleAppear)
        .confettiCannon(
            counter: self.$viewModel.confettiTimesRun,
            num: self.viewModel.numberOfConfettis,
            repetitions: self.viewModel.confettiRepetitions
        )
        .kPopUpLite(
            isPresented: self.$viewModel.showToast,
            style: .bottom(
                title: "Sorry, something went wrong".localized(comment: ""),
                type: .error,
                description: "Failed to make purchase".localized(comment: "")
            ),
            backgroundColor: self.colorScheme == .dark ? .black : .white
        )
    }

    private func handlePurchase(_ donation: CustomProduct) {
        self.store.purchaseDonation(donation) { result in
            switch result {
            case .failure:
                self.viewModel.openToast()
                return
            case .success:
                break
            }

            self.viewModel.shootConfetti(for: donation)
        }
    }

    private func handleAppear() {
        Task {
            let result = await store.requestProducts()
            switch result {
            case .failure: self.navigator.goBack()
            case .success: break
            }
        }
    }
}

private final class ViewModel: ObservableObject {
    @Published var confettiTimesRun = 0
    @Published private(set) var numberOfConfettis = 20
    @Published private(set) var confettiRepetitions = 0
    @Published var showToast = false
    private var toastTimer: Timer?

    func shootConfetti(for donation: CustomProduct) {
        let weight = donation.weight

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            if weight > 0 {
                self.confettiRepetitions = weight - 1
            }
            self.numberOfConfettis = 20 * weight
            self.confettiTimesRun += 1
        }
    }

    func openToast() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            if self.toastTimer != nil {
                self.toastTimer!.invalidate()
                self.toastTimer = nil
            }

            self.showToast = true
            self.toastTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { [weak self] _ in
                guard let self else { return }

                self.showToast = false
                self.toastTimer?.invalidate()
                self.toastTimer = nil
            })
        }
    }
}

// struct SupportAuthorScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        SupportAuthorScreen()
//    }
// }
