//
//  NativeTimeModuleBridge.m
//  iOSRN
//
//  Created by Codex on 2026/4/22.
//

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(NativeTimeModule, NSObject)

RCT_EXTERN_METHOD(getCurrentTime:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

@end
