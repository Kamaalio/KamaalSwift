//
//  KEnforcedFloatingDecimalField.swift
//  SalmonUI
//
//  Created by Kamaal Farah on 01/07/2021.
//

import SwiftUI

@available(watchOS 7.0, *)
public struct KEnforcedFloatingDecimalField: View {
    @State private var text = ""

    @Binding public var value: Double

    public let title: String

    public init(value: Binding<Double>, title: String) {
        self._value = value
        self.title = title
    }

    public var body: some View {
        KFloatingTextField(text: self.$text, title: self.title, textFieldType: .decimals)
            .onAppear(perform: self.onViewAppear)
            .onChange(of: self.text, perform: self.onTextChange(_:))
            .onChange(of: self.value, perform: self.onValueChange(_:))
    }

    private func onViewAppear() {
        let stringValue = String(value)
        if stringValue != self.text {
            self.text = stringValue
        }
    }

    private func onValueChange(_ newValue: Double) {
        let stringValue = String(newValue)
        if stringValue != self.text {
            self.text = stringValue
        }
    }

    private func onTextChange(_ changedText: String) {
        if let textAsDouble = Double(changedText) {
            if textAsDouble != self.value {
                self.value = textAsDouble
            }
        } else {
            let sanitizedDouble = String(changedText.sanitizedDouble)
            if sanitizedDouble != self.text {
                self.text = sanitizedDouble
            }
        }
    }
}

@available(watchOS 7.0, *)
struct KEnforcedFloatingDecimalField_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            KEnforcedFloatingDecimalField(value: .constant(0), title: "Tile")
                .previewLayout(.sizeThatFits)
                .padding(.vertical, 20)
            KEnforcedFloatingDecimalField(value: .constant(0), title: "Tile")
                .previewLayout(.sizeThatFits)
                .padding(.vertical, 20)
                .colorScheme(.dark)
                .background(Color.black)
        }
    }
}
