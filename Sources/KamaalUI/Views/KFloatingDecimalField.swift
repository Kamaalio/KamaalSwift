//
//  KFloatingDecimalField.swift
//
//
//  Created by Kamaal M Farah on 02/12/2023.
//

import SwiftUI

public struct KFloatingDecimalField: View {
    @State private var valueIsValid = true

    @Binding var value: String

    let title: String
    let fixButtonTitle: String
    let fixMessage: String

    public init(value: Binding<String>, title: String, fixButtonTitle: String, fixMessage: String) {
        self._value = value
        self.title = title
        self.fixButtonTitle = fixButtonTitle
        self.fixMessage = fixMessage
    }

    public var body: some View {
        VStack(alignment: .leading) {
            KTitledView(title: self.title) {
                HStack {
                    TextField("", text: self.$value)
                    #if os(iOS)
                        .padding(.horizontal, 16)
                    #endif
                    if !self.valueIsValid {
                        Button(action: self.fixValue) {
                            HStack(spacing: 0) {
                                Image(systemName: "hammer.fill")
                                Text(self.fixButtonTitle)
                                    .textCase(.uppercase)
                            }
                            .foregroundColor(.accentColor)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            if !self.valueIsValid {
                Text(self.fixMessage)
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
        }
        .onChange(of: self.value, perform: self.handleValueChange)
        .onAppear(perform: self.handleOnAppear)
    }

    private func handleValueChange(_ newValue: String) {
        let doubleValue = Double(newValue)
        if self.valueIsValid != (doubleValue != nil) {
            withAnimation { self.valueIsValid = (doubleValue != nil) }
        }
    }

    private func handleOnAppear() {
        self.handleValueChange(self.value)
    }

    private func fixValue() {
        guard !self.valueIsValid else { return }

        let sanitizedValue = self.value.sanitizedDouble
        self.value = String(sanitizedValue)
    }
}

struct KFloatingDecimalField_Previews: PreviewProvider {
    static var previews: some View {
        KFloatingDecimalField(
            value: .constant("0.0"),
            title: "Amount",
            fixButtonTitle: "Fix",
            fixMessage: "Invalid value"
        )
    }
}
