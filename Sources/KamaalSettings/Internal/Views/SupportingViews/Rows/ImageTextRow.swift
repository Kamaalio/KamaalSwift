//
//  ImageTextRow.swift
//
//
//  Created by Kamaal M Farah on 18/12/2022.
//

import SwiftUI
import KamaalUI
import KamaalExtensions

struct ImageTextRow: View {
    let label: String
    let imageName: String
    private let imageType: ImageType

    init(label: String, imageSystemName: String) {
        self.label = label
        self.imageName = imageSystemName
        self.imageType = .systemName
    }

    init(label: String, imageName: String) {
        self.label = label
        self.imageName = imageName
        self.imageType = .name
    }

    init(localizedLabel: String, comment: String, imageSystemName: String) {
        self.init(label: localizedLabel.localized(comment: comment), imageSystemName: imageSystemName)
    }

    private enum ImageType {
        case systemName
        case name
    }

    var body: some View {
        ValueRow(label: label) {
            switch imageType {
            case .systemName:
                Image(systemName: imageName)
            case .name:
                if let imageFromAsset {
                    imageFromAsset
                        .kSize(Constants.rowTileSize)
                        .cornerRadius(Constants.rowTileCornerRadius)
                }
            }
        }
    }

    private var imageFromAsset: Image? {
        #if canImport(UIKit)
        if let image = UIImage(named: imageName) {
            return Image(uiImage: image)
        }
        #else
        if let image = NSImage(named: imageName) {
            return Image(nsImage: image)
        }
        #endif

        return nil
    }
}

struct ImageTextRow_Previews: PreviewProvider {
    static var previews: some View {
        ImageTextRow(label: "Label", imageSystemName: "person")
    }
}
