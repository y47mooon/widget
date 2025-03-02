//
//  GaudyWidgetBundle.swift
//  GaudyWidget
//
//  Created by ゆぅ on 2025/03/01.
//

import WidgetKit
import SwiftUI

@main
struct GaudyWidgetBundle: WidgetBundle {
    var body: some Widget {
        GaudyWidget()
        GaudyWidgetControl()
        GaudyWidgetLiveActivity()
    }
}
