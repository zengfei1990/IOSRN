//
//  ReactViewController.swift
//  iOSRN
//
//  Created by Codex on 2026/4/21.
//

import React
import React_RCTAppDelegate
import ReactAppDependencyProvider
import UIKit

final class ReactViewController: UIViewController {

    private var reactNativeFactory: RCTReactNativeFactory?
    private var reactNativeFactoryDelegate: RCTReactNativeFactoryDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "RN Demo"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(close)
        )

        let delegate = ReactNativeDelegate()
        delegate.dependencyProvider = RCTAppDependencyProvider()

        reactNativeFactoryDelegate = delegate
        reactNativeFactory = RCTReactNativeFactory(delegate: delegate)
        view = reactNativeFactory?.rootViewFactory.view(
            withModuleName: "DemoRNPage",
            initialProperties: [
                "source": "Presented from native Swift"
            ]
        )
    }

    @objc private func close() {
        dismiss(animated: true)
    }
}

private final class ReactNativeDelegate: RCTDefaultReactNativeFactoryDelegate {
    override func sourceURL(for bridge: RCTBridge) -> URL? {
        bundleURL()
    }

    override func bundleURL() -> URL? {
        #if DEBUG
        if let bundledURL = Bundle.main.url(forResource: "main", withExtension: "jsbundle") {
            return bundledURL
        }
        return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
        #else
        return Bundle.main.url(forResource: "main", withExtension: "jsbundle")
        #endif
    }
}
