# iOSRN

一个用于学习的最小示例工程：在 **iOS 原生 UIKit 工程** 中嵌入一个 **React Native 模块**，并演示几种最常见的 Native / RN 通信方式。

这个项目不是一个完整的纯 RN App，而是更接近真实业务里的接入方式：

- 原生 iOS 作为宿主
- RN 作为一个业务页面或业务模块被打开
- Native 和 RN 之间通过参数、事件、Promise 等方式通信

## 项目目标

这个 demo 主要演示四件事：

1. 原生页面如何打开 RN 页面
2. RN 页面 UI 写在哪里
3. RN 如何调用 Native 能力
4. Native 如何把消息回传给 RN

## 目录说明

核心文件如下：

- [iOSRN/ViewController.swift](./iOSRN/ViewController.swift)
  - 原生首页，点击按钮打开 RN 页面
- [iOSRN/ReactViewController.swift](./iOSRN/ReactViewController.swift)
  - RN 容器页，负责加载 `DemoRNPage`
- [index.js](./index.js)
  - RN 页面本体，包含 UI 和通信示例
- [iOSRN/NativeMessenger.swift](./iOSRN/NativeMessenger.swift)
  - RN -> Native：调用原生方法弹 Alert
- [iOSRN/NativeEventEmitter.swift](./iOSRN/NativeEventEmitter.swift)
  - Native -> RN：通过事件把消息发送给 RN
- [iOSRN/NativeTimeModule.swift](./iOSRN/NativeTimeModule.swift)
  - RN -> Native：通过 Promise 异步获取原生时间
- [iOSRN/NativeMessengerBridge.m](./iOSRN/NativeMessengerBridge.m)
- [iOSRN/NativeEventEmitterBridge.m](./iOSRN/NativeEventEmitterBridge.m)
- [iOSRN/NativeTimeModuleBridge.m](./iOSRN/NativeTimeModuleBridge.m)
  - Swift 模块桥接到 RN 的 Objective-C 声明文件
- [Podfile](./Podfile)
  - iOS 侧 RN 依赖接入
- [package.json](./package.json)
  - JS 依赖和打包命令

## 运行方式

### 1. 安装 JS 依赖

```bash
npm install
```

### 2. 安装 CocoaPods 依赖

```bash
pod install
```

### 3. 生成离线 JS bundle

```bash
npm run bundle:ios
```

这条命令会把 [index.js](./index.js) 打包成：

```text
iOSRN/main.jsbundle
```

### 4. 用 Xcode 打开工程

请打开：

```text
iOSRN.xcworkspace
```

不要直接打开 `iOSRN.xcodeproj`，因为 RN 的 pod 依赖是通过 workspace 管理的。

## 页面流程

启动 App 后流程如下：

```text
ViewController.swift
    -> 点击 Open React Native
    -> ReactViewController.swift
    -> 加载 DemoRNPage
    -> index.js 渲染 RN 页面
```

其中 [ReactViewController.swift](./iOSRN/ReactViewController.swift) 里最关键的是：

```swift
view = reactNativeFactory?.rootViewFactory.view(
    withModuleName: "DemoRNPage",
    initialProperties: [
        "source": "Presented from native Swift"
    ]
)
```

这里的 `DemoRNPage` 要和 [index.js](./index.js) 里的：

```js
AppRegistry.registerComponent('DemoRNPage', () => DemoRNPage);
```

保持一致。

## 通信示例

### 1. Native -> RN：初始化参数

原生在创建 RN 页面时传入：

```swift
initialProperties: [
    "source": "Presented from native Swift"
]
```

RN 页面通过 `props.source` 读取。

适合用于：

- 页面来源
- 用户 id
- 首屏参数
- 业务类型

### 2. RN -> Native：普通方法调用

RN 中：

```js
NativeMessenger?.showMessage('This alert is presented by native iOS.');
```

Native 中：

- [iOSRN/NativeMessengerBridge.m](./iOSRN/NativeMessengerBridge.m) 负责导出模块
- [iOSRN/NativeMessenger.swift](./iOSRN/NativeMessenger.swift) 负责真正实现

这个 demo 里最终会弹出原生 `UIAlertController`。

### 3. Native -> RN：事件

原生右上角按钮 `Send to RN` 会调用：

```swift
NativeEventEmitter.emit(message: message)
```

RN 中通过：

```js
eventEmitter.addListener('NativeMessage', ...)
```

监听并更新页面状态。

适合用于：

- 登录态变化
- 播放状态变化
- 上传进度
- 原生生命周期通知

### 4. RN -> Native：Promise 异步返回

RN 中：

```js
const time = await NativeTimeModule.getCurrentTime();
```

Native 中：

- [iOSRN/NativeTimeModuleBridge.m](./iOSRN/NativeTimeModuleBridge.m) 负责声明导出
- [iOSRN/NativeTimeModule.swift](./iOSRN/NativeTimeModule.swift) 负责异步返回结果

适合用于：

- 读取原生缓存
- 获取设备信息
- 调系统能力后回传结果
- 调 SDK 异步接口

## JS bundle 是什么

[index.js](./index.js) 是 RN 源码入口。

执行：

```bash
npm run bundle:ios
```

后，会生成：

- [iOSRN/main.jsbundle](./iOSRN/main.jsbundle)

这个文件就是打包后的 RN 代码。运行时 `ReactViewController` 会通过：

```swift
Bundle.main.url(forResource: "main", withExtension: "jsbundle")
```

加载它。

## iOS 侧依赖

[Podfile](./Podfile) 中使用了：

```ruby
use_react_native!(
  :path => config[:reactNativePath],
  :app_path => Pod::Config.instance.installation_root.to_s
)
```

这会自动接入 RN 所需的 iOS 组件，核心包括：

- `React-Core`
- `React-RCTRuntime`
- `React-RCTText`
- `React-Fabric`
- `Yoga`
- `ReactCodegen`
- `ReactAppDependencyProvider`
- `hermes-engine`
- `React-hermes`

这个项目还在 `post_install` 中关闭了：

```ruby
ENABLE_USER_SCRIPT_SANDBOXING = 'NO'
```

用于避免 Hermes / CocoaPods 在复制 framework 时出现 `rsync deny` 问题。

## JS 侧依赖

[package.json](./package.json) 中的核心依赖：

- `react`
- `react-native`

以及开发工具：

- `@babel/core`
- `@react-native-community/cli`
- `@react-native/babel-preset`
- `@react-native/metro-config`

## 学习建议

如果你是第一次接触“原生项目嵌入 RN”，建议按这个顺序看代码：

1. [iOSRN/ViewController.swift](./iOSRN/ViewController.swift)
2. [iOSRN/ReactViewController.swift](./iOSRN/ReactViewController.swift)
3. [index.js](./index.js)
4. [iOSRN/NativeMessenger.swift](./iOSRN/NativeMessenger.swift)
5. [iOSRN/NativeEventEmitter.swift](./iOSRN/NativeEventEmitter.swift)
6. [iOSRN/NativeTimeModule.swift](./iOSRN/NativeTimeModule.swift)
7. 三个 `Bridge.m` 文件

建议重点理解这几个问题：

- 原生 VC 是怎么承载 RN UI 的
- `DemoRNPage` 是怎么和 JS 组件对应上的
- `main.jsbundle` 是怎么生成和加载的
- Native 和 RN 为什么需要桥接
- 不同通信方式分别适合什么场景

## 当前示例页面功能

RN 页面里现在可以看到：

- 一个绿色按钮：`Tap Here: Show iOS Alert`
  - 演示 RN -> Native 普通方法调用
- 一个蓝色按钮：`Ask Native For Time`
  - 演示 RN -> Native Promise
- 一个右上角导航按钮：`Send to RN`
  - 演示 Native -> RN 事件
- 一个 `Native prop` 区域
  - 演示 Native -> RN 初始化参数

## 备注

这是一个学习型 demo，代码重点在于把 RN 嵌入原生和基础通信链路跑通，而不是做完整业务架构。

如果后续要往真实项目演进，通常会继续补：

- 页面拆分
- 业务 service 层
- Native bridge 封装层
- 状态管理
- 多页面 / 多 bundle 管理
- iOS / Android 双端统一接口设计
