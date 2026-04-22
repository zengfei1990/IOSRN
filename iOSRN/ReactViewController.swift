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

    // factory 持有创建 RN 页面所需的运行时对象。
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Send to RN",
            style: .plain,
            target: self,
            action: #selector(sendMessageToReactNative)
        )

        let delegate = ReactNativeDelegate()
        delegate.dependencyProvider = RCTAppDependencyProvider()

        reactNativeFactoryDelegate = delegate
        reactNativeFactory = RCTReactNativeFactory(delegate: delegate)
        // 这里的 "DemoRNPage" 必须和 index.js 里注册的组件名保持一致。
        view = reactNativeFactory?.rootViewFactory.view(
            withModuleName: "DemoRNPage",
            initialProperties: [
                // 这是最简单的 Native -> RN 通信方式：页面初始化时传一次启动参数。
                "source": "Presented from native Swift"
            ]
        )
    }

    @objc private func close() {
        dismiss(animated: true)
    }

    @objc private func sendMessageToReactNative() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        let message = "Native says hello at \(formatter.string(from: Date()))"
        // 这里演示的是页面加载完成后，Native 主动发消息给 RN。
        NativeEventEmitter.emit(message: message)
    }
}

private final class ReactNativeDelegate: RCTDefaultReactNativeFactoryDelegate {
    override func sourceURL(for bridge: RCTBridge) -> URL? {
        bundleURL()
    }

    override func bundleURL() -> URL? {
        #if DEBUG
        // 真机或离线场景优先使用打进 App 的 JS bundle，这样不依赖 Metro。
        if let bundledURL = Bundle.main.url(forResource: "main", withExtension: "jsbundle") {
            return bundledURL
        }
        // 如果没有离线 bundle，再退回到 Metro 开发服务。
        return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
        #else
        return Bundle.main.url(forResource: "main", withExtension: "jsbundle")
        #endif
    }
}
