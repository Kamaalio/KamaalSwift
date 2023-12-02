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
            KTitledView(title: title) {
                HStack {
                    TextField("", text: $value)
                        #if os(iOS)
                        .padding(.horizontal, .medium)
                        #endif
                    if !valueIsValid {
                        Button(action: fixValue) {
                            HStack(spacing: 0) {
                                Image(systemName: "hammer.fill")
                                Text(fixButtonTitle)
                                    .textCase(.uppercase)
                            }
                            .foregroundColor(.accentColor)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            if !valueIsValid {
                Text(fixMessage)
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
        }
        .onChange(of: value, perform: handleValueChange)
        .onAppear(perform: handleOnAppear)
    }

    private func handleValueChange(_ newValue: String) {
        let doubleValue = Double(newValue)
        if valueIsValid != (doubleValue != nil) {
            withAnimation { valueIsValid = (doubleValue != nil) }
        }
    }

    private func handleOnAppear() {
        handleValueChange(value)
    }

    private func fixValue() {
        guard !valueIsValid else { return }

        let sanitizedValue = value.sanitizedDouble
        value = String(sanitizedValue)
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
