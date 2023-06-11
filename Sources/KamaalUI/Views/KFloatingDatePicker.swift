//
//  KFloatingDatePicker.swift
//  SalmonUI
//
//  Created by Kamaal Farah on 01/07/2021.
//

#if !os(watchOS)
import SwiftUI

public struct KFloatingDatePicker: View {
    @Binding public var value: Date

    public let title: String
    public let displayedComponents: DatePicker.Components
    public let onChange: (_ newValue: Date) -> Void

    public init(
        value: Binding<Date>,
        title: String,
        displayedComponents: DatePicker.Components = .date,
        onChange: @escaping (_ newValue: Date) -> Void = { _ in }
    ) {
        self._value = value
        self.title = title
        self.displayedComponents = displayedComponents
        self.onChange = onChange
    }

    public var body: some View {
        ZStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.accentColor)
                .offset(y: -25)
                .scaleEffect(0.75, anchor: .leading)
                .padding(.horizontal, 4)
            DatePicker("", selection: $value, displayedComponents: displayedComponents)
                .labelsHidden()
        }
        .padding(.top, 12)
        .onChange(of: value, perform: onChange)
    }
}

struct KFloatingDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        KFloatingDatePicker(value: .constant(Date()), title: "Date", onChange: { _ in })
    }
}
#endif
