import React, {useEffect, useMemo, useState} from 'react';
import {
  NativeEventEmitter,
  NativeModules,
  SafeAreaView,
  StatusBar,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import {AppRegistry} from 'react-native';

const moduleName = 'DemoRNPage';
const {
  NativeEventEmitter: NativeEventModule,
  NativeMessenger,
  NativeTimeModule,
} = NativeModules;

function showNativeMessage() {
  // 最基础的 RN -> Native 方法调用。
  NativeMessenger?.showMessage('This alert is presented by native iOS.');
}

function DemoRNPage(props) {
  const [nativeLiveMessage, setNativeLiveMessage] = useState('No live event yet');
  const [nativeTime, setNativeTime] = useState('Tap the button below to request time');
  const [isLoadingTime, setIsLoadingTime] = useState(false);
  const eventEmitter = useMemo(() => {
    if (!NativeEventModule) {
      return null;
    }
    // 把原生事件模块包装成 JS 可订阅的事件源。
    return new NativeEventEmitter(NativeEventModule);
  }, []);

  useEffect(() => {
    if (!eventEmitter) {
      return undefined;
    }

    // 页面运行过程中，Native 每发一次事件，RN 就更新一次本地状态。
    const subscription = eventEmitter.addListener('NativeMessage', payload => {
      setNativeLiveMessage(payload?.message ?? 'Received an empty message');
    });

    return () => {
      subscription.remove();
    };
  }, [eventEmitter]);

  async function fetchNativeTime() {
    if (!NativeTimeModule?.getCurrentTime) {
      setNativeTime('NativeTimeModule is unavailable');
      return;
    }

    try {
      setIsLoadingTime(true);
      // Promise 风格的 RN -> Native 异步调用。
      const time = await NativeTimeModule.getCurrentTime();
      setNativeTime(`Native async time: ${time}`);
    } catch (error) {
      setNativeTime(`Request failed: ${String(error)}`);
    } finally {
      setIsLoadingTime(false);
    }
  }

  return (
    <SafeAreaView style={styles.safeArea}>
      <StatusBar barStyle="dark-content" />
      <View style={styles.container}>
        <Text style={styles.eyebrow}>React Native Module</Text>
        <Text style={styles.title}>Hello from VS Code</Text>
        <Text style={styles.version}>{'Native <-> RN demo v3'}</Text>
        <TouchableOpacity
          style={styles.primaryButton}
          activeOpacity={0.78}
          onPress={showNativeMessage}>
          <Text style={styles.primaryButtonText}>Tap Here: Show iOS Alert</Text>
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.secondaryButton}
          activeOpacity={0.78}
          onPress={fetchNativeTime}>
          <Text style={styles.secondaryButtonText}>
            {isLoadingTime ? 'Loading Native Time...' : 'Ask Native For Time'}
          </Text>
        </TouchableOpacity>
        <Text style={styles.body}>
          This screen is rendered by JavaScript and mounted inside the native
          iOS app.
        </Text>
        <View style={styles.infoBox}>
          <Text style={styles.infoLabel}>Native prop</Text>
          <Text style={styles.infoValue}>{props.source ?? 'Unknown'}</Text>
        </View>
        <View style={styles.infoBox}>
          <Text style={styles.infoLabel}>Live event from Native</Text>
          <Text style={styles.infoValue}>{nativeLiveMessage}</Text>
        </View>
        <View style={styles.infoBox}>
          <Text style={styles.infoLabel}>Promise result from Native</Text>
          <Text style={styles.infoValue}>{nativeTime}</Text>
        </View>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {
    flex: 1,
    backgroundColor: '#F7F7F2',
  },
  container: {
    flex: 1,
    justifyContent: 'center',
    paddingHorizontal: 28,
  },
  eyebrow: {
    color: '#4D7C8A',
    fontSize: 13,
    fontWeight: '700',
    marginBottom: 10,
    textTransform: 'uppercase',
  },
  title: {
    color: '#111827',
    fontSize: 34,
    fontWeight: '800',
    marginBottom: 8,
  },
  version: {
    color: '#1F7A8C',
    fontSize: 15,
    fontWeight: '700',
    marginBottom: 14,
  },
  primaryButton: {
    alignItems: 'center',
    backgroundColor: '#1B7F3A',
    borderRadius: 8,
    height: 56,
    justifyContent: 'center',
    marginBottom: 22,
  },
  primaryButtonText: {
    color: '#FFFFFF',
    fontSize: 17,
    fontWeight: '800',
  },
  secondaryButton: {
    alignItems: 'center',
    backgroundColor: '#155E75',
    borderRadius: 8,
    height: 52,
    justifyContent: 'center',
    marginBottom: 18,
  },
  secondaryButtonText: {
    color: '#FFFFFF',
    fontSize: 16,
    fontWeight: '700',
  },
  body: {
    color: '#4B5563',
    fontSize: 17,
    lineHeight: 25,
    marginBottom: 26,
  },
  infoBox: {
    backgroundColor: '#FFFFFF',
    borderColor: '#E5E7EB',
    borderRadius: 8,
    borderWidth: 1,
    marginBottom: 22,
    padding: 16,
  },
  infoLabel: {
    color: '#6B7280',
    fontSize: 13,
    marginBottom: 6,
  },
  infoValue: {
    color: '#111827',
    fontSize: 18,
    fontWeight: '700',
  },
});

AppRegistry.registerComponent(moduleName, () => DemoRNPage);
