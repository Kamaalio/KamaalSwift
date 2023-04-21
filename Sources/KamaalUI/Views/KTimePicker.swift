//
//  KTimePicker.swift
//  KamaalUI
//
//  Created by Kamaal Farah on 06/05/2020.
//

import SwiftUI

#if !os(macOS)
public struct KTimePicker: View {
    public var selection: Binding<Int>
    public var steps: Int
    public var range: Range<Int>

    public init(selection: Binding<Int>, steps: Int, range: Range<Int>) {
        self.selection = selection
        self.steps = steps
        self.range = range
    }

    public var body: some View {
        VStack {
            Picker("", selection: selection) {
                ForEach(range) {
                    Text(String(format: "%02d", $0 * self.steps))
                }
            }
            .labelsHidden()
            .pickerStyle(WheelPickerStyle())
            .frame(minWidth: 75, maxWidth: 75)
            .clipped()
            .padding(.horizontal)
        }
    }
}
#endif
