//
//  String+extensions.swift
//
//
//  Created by Kamaal M Farah on 18/12/2022.
//

import Foundation

extension String {
    func localized(comment: String, with variables: [CVarArg] = []) -> String {
        let bundle = Bundle.module
        let localizedString = NSLocalizedString(self, bundle: bundle, comment: comment)
        switch variables {
        case _ where variables.isEmpty:
            return localizedString
        case _ where variables.count == 1:
            return String(format: localizedString, variables[0])
        default:
            assertionFailure("amount of variables not supported yet")
            return localizedString
        }
    }
}
