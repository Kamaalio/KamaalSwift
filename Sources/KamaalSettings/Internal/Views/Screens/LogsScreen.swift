//
//  LogsScreen.swift
//
//
//  Created by Kamaal M Farah on 23/12/2022.
//

import SwiftUI
import KamaalUI
import KamaalLogger
import KamaalNavigation

struct LogsScreen<ScreenType: NavigatorStackValue>: View {
    @EnvironmentObject private var navigator: Navigator<ScreenType>

    @Environment(\.settingsConfiguration) private var settingsConfiguration: SettingsConfiguration

    @State private var logs: [HoldedLog] = []
    @State private var selectedLog: HoldedLog?
    @State private var showSelectedLogSheet = false
    @State private var bugDescription = ""

    let screenMapping: (_ settingsSelection: SettingsScreenSelection) -> ScreenType

    private enum Screens: Hashable {
        case feedback
    }

    var body: some View {
        ZStack {
            KScrollableForm {
                KSection {
                    if self.logs.isEmpty {
                        AppText(localizedString: "No logs available", comment: "")
                            .ktakeWidthEagerly(alignment: .leading)
                    }
                    ForEach(self.logs, id: \.self) { item in
                        LogRow(log: item, action: self.onLogPress)
                        #if os(macOS)
                        if item != self.logs.last {
                            Divider()
                        }
                        #endif
                    }
                }
                #if os(macOS)
                .padding(.all, .medium)
                #endif
            }
            .ktakeSizeEagerly(alignment: .topLeading)
        }
        .onAppear(perform: self.handleOnAppear)
        .onChange(of: self.showSelectedLogSheet, perform: self.onShowSelectedLogSheetChange)
        .sheet(isPresented: self.$showSelectedLogSheet, content: {
            LogDetailsSheet(log: self.selectedLog, close: self.closeSheet, reportBug: self.reportBug)
                .accentColor(self.settingsConfiguration.currentColor)
        })
    }

    private func closeSheet() {
        self.showSelectedLogSheet = false
    }

    private func reportBug(_ log: HoldedLog) {
        self.closeSheet()

        let predefinedDescription = """
        # Reported log

        label: \(log.label)
        type: \(log.level.rawValue)
        message: \(log.message)


        """

        self.bugDescription = predefinedDescription
        self.navigator.navigate(to: self.screenMapping(.feedback(style: .bug, description: predefinedDescription)))
    }

    private func onShowSelectedLogSheetChange(_ newValue: Bool) {
        if !newValue {
            self.selectedLog = .none
        }
    }

    private func handleOnAppear() {
        Task {
            self.logs = await LogHolder.shared.logs.reversed()
        }
    }

    private func onLogPress(_ log: HoldedLog) {
        self.selectedLog = log
        self.showSelectedLogSheet = true
    }
}

// struct LogsScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        LogsScreen()
//    }
// }
