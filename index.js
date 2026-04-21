import React from 'react';
import {
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
const {NativeMessenger} = NativeModules;

function showNativeMessage() {
  NativeMessenger?.showMessage('This alert is presented by native iOS.');
}

function DemoRNPage(props) {
  return (
    <SafeAreaView style={styles.safeArea}>
      <StatusBar barStyle="dark-content" />
      <View style={styles.container}>
        <Text style={styles.eyebrow}>React Native Module</Text>
        <Text style={styles.title}>Hello from RN</Text>
        <Text style={styles.version}>RN -> Native demo v2</Text>
        <TouchableOpacity
          style={styles.primaryButton}
          activeOpacity={0.78}
          onPress={showNativeMessage}>
          <Text style={styles.primaryButtonText}>Tap Here: Show iOS Alert</Text>
        </TouchableOpacity>
        <Text style={styles.body}>
          This screen is rendered by JavaScript and mounted inside the native
          iOS app.
        </Text>
        <View style={styles.infoBox}>
          <Text style={styles.infoLabel}>Native prop</Text>
          <Text style={styles.infoValue}>{props.source ?? 'Unknown'}</Text>
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
