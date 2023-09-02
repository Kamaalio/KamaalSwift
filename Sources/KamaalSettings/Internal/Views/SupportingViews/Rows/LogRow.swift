//
//  LogRow.swift
//
//
//  Created by Kamaal M Farah on 23/12/2022.
//

import SwiftUI
import KamaalUI
import KamaalLogger

struct LogRow: View {
    let log: HoldedLog
    let action: (_ log: HoldedLog) -> Void

    var body: some View {
        AppButton(action: { self.action(self.log) }) {
            HStack(alignment: .top, spacing: 8) {
                Text(self.log.label)
                    .foregroundColor(self.log.level.color)
                Text(self.log.message)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
            .ktakeWidthEagerly(alignment: .leading)
        }
    }
}

struct LogRow_Previews: PreviewProvider {
    static var previews: some View {
        LogRow(
            log: .init(label: "LogRow", level: .info, message: "Preview", timestamp: Date.distantPast),
            action: { _ in }
        )
    }
}
