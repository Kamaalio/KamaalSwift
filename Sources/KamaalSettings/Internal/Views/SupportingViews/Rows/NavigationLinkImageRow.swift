//
//  NavigationLinkImageRow.swift
//
//
//  Created by Kamaal M Farah on 18/12/2022.
//

import SwiftUI
import KamaalNavigation

struct NavigationLinkImageRow<ScreenType: NavigatorStackValue>: View {
    let label: String
    let imageName: String
    let destination: ScreenType
    private let imageType: ImageType

    init(label: String, imageName: String, destination: ScreenType) {
        self.label = label
        self.imageName = imageName
        self.destination = destination
        self.imageType = .name
    }

    init(localizedLabel: String, comment: String, imageName: String, destination: ScreenType) {
        self.init(label: localizedLabel.localized(comment: comment), imageName: imageName, destination: destination)
    }

    init(label: String, imageSystemName: String, destination: ScreenType) {
        self.label = label
        self.imageName = imageSystemName
        self.destination = destination
        self.imageType = .systemName
    }

    init(localizedLabel: String, comment: String, imageSystemName: String, destination: ScreenType) {
        self.init(
            label: localizedLabel.localized(comment: comment),
            imageSystemName: imageSystemName,
            destination: destination,
        )
    }

    private enum ImageType {
        case systemName
        case name
    }

    var body: some View {
        NavigationLinkRow(destination: self.destination) {
            switch self.imageType {
            case .systemName:
                ImageTextRow(label: self.label, imageSystemName: self.imageName)
            case .name:
                ImageTextRow(label: self.label, imageName: self.imageName)
            }
        }
    }
}

// struct NavigationLinkImageRow_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationLinkImageRow(label: "Label", imageSystemName: "person", destination: .acknowledgements)
//    }
// }
