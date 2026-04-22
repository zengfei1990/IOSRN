//
//  NativeTimeModule.swift
//  iOSRN
//
//  Created by Codex on 2026/4/22.
//

import Foundation
import React

@objc(NativeTimeModule)
final class NativeTimeModule: NSObject {

    @objc
    static func requiresMainQueueSetup() -> Bool {
        false
    }

    @objc(getCurrentTime:rejecter:)
    func getCurrentTime(
        _ resolve: @escaping RCTPromiseResolveBlock,
        rejecter reject: @escaping RCTPromiseRejectBlock
    ) {
        // 模拟一个异步原生任务，方便演示 RN 侧如何用 Promise / await 接结果。
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.35) {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "zh_CN")
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let timeString = formatter.string(from: Date())
            resolve(timeString)
        }
    }
}
