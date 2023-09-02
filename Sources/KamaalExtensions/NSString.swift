//
//  NSString.swift
//
//
//  Created by Kamaal M Farah on 27/02/2021.
//

import Foundation

extension NSString {
    public var uuid: UUID? {
        UUID(uuidString: self.string)
    }

    public var string: String {
        String(self)
    }
}
