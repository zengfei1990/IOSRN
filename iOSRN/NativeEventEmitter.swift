//
//  NativeEventEmitter.swift
//  iOSRN
//
//  Created by Codex on 2026/4/22.
//

import Foundation
import React

@objc(NativeEventEmitter)
final class NativeEventEmitter: RCTEventEmitter {

    // 保存一个共享引用，这样普通原生代码也能直接向 RN 发事件。
    private static weak var currentEmitter: NativeEventEmitter?
    private var hasListeners = false

    override init() {
        super.init()
        Self.currentEmitter = self
    }

    @objc
    override static func requiresMainQueueSetup() -> Bool {
        true
    }

    override func supportedEvents() -> [String]! {
        ["NativeMessage"]
    }

    override func startObserving() {
        hasListeners = true
    }

    override func stopObserving() {
        hasListeners = false
    }

    static func emit(message: String) {
        // 如果 RN 还没有开始监听，就不发送，避免消息直接丢失。
        guard let emitter = currentEmitter, emitter.hasListeners else {
            return
        }

        let payload: [String: String] = [
            "message": message,
            "sentAt": ISO8601DateFormatter().string(from: Date())
        ]
        emitter.sendEvent(withName: "NativeMessage", body: payload)
    }
}
