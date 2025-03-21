//
//  String+Localization.swift
//  widgetoshinoko
//
//  Created by ゆぅ on 2025/03/21.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
