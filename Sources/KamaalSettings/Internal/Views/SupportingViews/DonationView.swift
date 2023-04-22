//
//  DonationView.swift
//
//
//  Created by Kamaal M Farah on 18/12/2022.
//

import SwiftUI
import KamaalExtensions

struct DonationView: View {
    let donation: CustomProduct

    init(donation: CustomProduct) {
        self.donation = donation
    }

    var body: some View {
        HStack {
            AppText(string: donation.emoji.string)
            VStack(alignment: .center) {
                AppText(
                    localizedString: "Buy me a %@",
                    comment: "%@ as in the item to buy",
                    with: [donation.displayName]
                )
                .textCase(.uppercase)
                .font(.headline)
                .foregroundColor(.primary)
                AppText(string: donation.description)
                    .textCase(.uppercase)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            Spacer()
            AppText(string: donation.displayPrice)
                .bold()
                .font(.headline)
                .foregroundColor(.accentColor)
        }
        .padding(.all, .medium)
        .background(Color.primary.opacity(0.2))
        .cornerRadius(.small)
    }
}

struct DonationView_Previews: PreviewProvider {
    static var previews: some View {
        DonationView(
            donation: .carrot
        )
    }
}
