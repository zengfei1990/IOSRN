//
//  NativeMessengerBridge.m
//  iOSRN
//
//  Created by Codex on 2026/4/21.
//

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(NativeMessenger, NSObject)

RCT_EXTERN_METHOD(showMessage:(NSString *)message)

@end
