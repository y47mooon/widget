//
//  ContentView.swift
//  widgetoshinoko
//
//  Created by ゆぅ on 2025/02/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ReactNativeView()
    }
}

struct ReactNativeView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        guard let jsCodeLocation = RCTBundleURLProvider.sharedSettings()?
            .jsBundleURL(forBundleRoot: "index", fallbackResource: nil) else {
            fatalError("Could not load JS bundle")
        }
        
        let rootView = RCTRootView(
            bundleURL: jsCodeLocation,
            moduleName: "widgetoshinoko",
            initialProperties: [:] as [String : Any],
            launchOptions: nil
        )
        
        let viewController = UIViewController()
        viewController.view = rootView
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

#Preview {
    ContentView()
}
