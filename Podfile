source 'https://github.com/CocoaPods/Specs.git'

# For this learning/demo project we prefer local source pods over React Native's
# large prebuilt Maven artifacts, which can be slow to download on some networks.
ENV['RCT_USE_RN_DEP'] = '0'
ENV['RCT_USE_PREBUILT_RNCORE'] = '0'

# Resolve React Native's CocoaPods helper through node so the file still works
# if node_modules is hoisted by the package manager.
require Pod::Executable.execute_command(
  'node',
  [
    '-p',
    'require.resolve("react-native/scripts/react_native_pods.rb", {paths: [process.argv[1]]})',
    __dir__
  ]
).strip

platform :ios, min_ios_version_supported
prepare_react_native_project!

target 'iOSRN' do
  config = use_native_modules!

  # use_react_native! is React Native's official CocoaPods entry.
  # It expands to the native pods required by RN, roughly including:
  #
  # - React-Core: React Native runtime and core iOS integration.
  # - React-RCTAppDelegate: App/delegate helpers used by RCTReactNativeFactory.
  # - React-RCTRuntime: runtime host and bridge/runtime setup.
  # - React-RCTText / React-RCTImage / React-RCTNetwork: built-in RN modules.
  # - React-Fabric / React-graphics / Yoga: New Architecture renderer and layout.
  # - ReactCodegen / ReactAppDependencyProvider: generated dependency providers.
  # - ReactCommon, React-jsi, React-callinvoker: C++ runtime infrastructure.
  # - hermes-engine / React-hermes / React-RuntimeHermes: default JS engine in RN 0.85.
  # - DoubleConversion, RCT-Folly, boost, fmt, glog, fast_float: third-party C++ deps.
  #
  # The concrete pod list is generated into Pods/Local Podspecs after pod install starts.
  use_react_native!(
    :path => config[:reactNativePath],
    :app_path => Pod::Config.instance.installation_root.to_s
  )

  post_install do |installer|
    react_native_post_install(
      installer,
      config[:reactNativePath],
      :mac_catalyst_enabled => false
    )

    # RN/Hermes and CocoaPods framework copy phases use rsync. Xcode's user
    # script sandbox can block those generated scripts from reading/writing
    # DerivedData, causing "Sandbox: rsync deny" build errors.
    installer.aggregate_targets.each do |aggregate_target|
      aggregate_target.user_project.native_targets.each do |native_target|
        native_target.build_configurations.each do |build_configuration|
          build_configuration.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
        end
      end

      aggregate_target.user_project.build_configurations.each do |build_configuration|
        build_configuration.build_settings['ENABLE_USER_SCRIPT_SANDBOXING'] = 'NO'
      end

      aggregate_target.user_project.save
    end
  end
end
