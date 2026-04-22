//
//  NativeMessenger.swift
//  iOSRN
//
//  Created by Codex on 2026/4/21.
//

import React
import UIKit

@objc(NativeMessenger)
final class NativeMessenger: NSObject {

    @objc
    static func requiresMainQueueSetup() -> Bool {
        true
    }

    @objc(showMessage:)
    func showMessage(_ message: String) {
        // RN 调到原生模块时不一定在主线程，因此这里统一切回主线程更新 UI。
        DispatchQueue.main.async {
            guard let viewController = Self.topViewController() else {
                return
            }

            let alertController = UIAlertController(
                title: "Message from RN",
                message: message,
                preferredStyle: .alert
            )
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            viewController.present(alertController, animated: true)
        }
    }

    private static func topViewController() -> UIViewController? {
        // 找到当前前台窗口里的顶层控制器，用来安全地弹出原生 Alert。
        let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
        let rootViewController = scene?.windows.first { $0.isKeyWindow }?.rootViewController
        return topViewController(from: rootViewController)
    }

    private static func topViewController(from viewController: UIViewController?) -> UIViewController? {
        if let navigationController = viewController as? UINavigationController {
            return topViewController(from: navigationController.visibleViewController)
        }

        if let tabBarController = viewController as? UITabBarController {
            return topViewController(from: tabBarController.selectedViewController)
        }

        if let presentedViewController = viewController?.presentedViewController {
            return topViewController(from: presentedViewController)
        }

        return viewController
    }
}
