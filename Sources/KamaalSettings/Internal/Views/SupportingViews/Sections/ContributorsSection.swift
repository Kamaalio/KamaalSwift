//
//  ContributorsSection.swift
//
//
//  Created by Kamaal M Farah on 23/12/2022.
//

import SwiftUI
import KamaalUI

struct ContributorsSection: View {
    @State private var kamaalTapTimes = 0

    let contributors: [Acknowledgements.Contributor]

    var body: some View {
        KSection(header: "Contributors".localized(comment: "")) {
            ForEach(self.contributors, id: \.self) { contributor in
                AppText(string: contributor.name)
                    .bold()
                    .ktakeWidthEagerly(alignment: .leading)
                    .onTapGesture(perform: { self.handleContributorTap(contributor) })
                #if os(macOS)
                if contributor != self.contributors.last {
                    Divider()
                }
                #endif
            }
            if self.kamaalTapTimes > 0, (self.kamaalTapTimes % 3) == 0 {
                Image("GoodJobKamaal", bundle: .module)
                    .resizable()
                    .padding(.horizontal, .medium)
            }
        }
        .padding(.horizontal, .medium)
        .padding(.top, .medium)
    }

    private func handleContributorTap(_ contributor: Acknowledgements.Contributor) {
        if contributor.name == "Kamaal Farah" {
            withAnimation { self.kamaalTapTimes += 1 }
        }
    }
}

struct ContributorsSection_Previews: PreviewProvider {
    static var previews: some View {
        ContributorsSection(contributors: [])
    }
}
