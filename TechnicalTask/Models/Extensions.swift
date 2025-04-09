//
//  Extensions.swift
//  TechnicalTask
//
//  Created by Vinh Tran on 10/4/2025.
//

import SwiftUI

extension String {
    public var localized: String {
        localized(with: [])
    }
    
    public func localized(with arguments: any CVarArg...) -> String {
        let format = NSLocalizedString(self, comment: "")
        return .localizedStringWithFormat(format, arguments)
    }
}

