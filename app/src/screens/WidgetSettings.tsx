import React from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
} from 'react-native';
import { useWidgetSettings } from '../hooks/useWidgetSettings';
import SettingItem from '../components/SettingItem';

export const WidgetSettings = () => {
  const { settings, updateSetting } = useWidgetSettings();

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.headerTitle}>Widget Settings</Text>
      </View>
      
      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Display Options</Text>
        <SettingItem
          label="Dark Mode"
          value={settings.isDarkMode}
          onValueChange={(value) => updateSetting('isDarkMode', value)}
        />
        <SettingItem
          label="Notifications"
          value={settings.isNotificationEnabled}
          onValueChange={(value) => updateSetting('isNotificationEnabled', value)}
        />
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  header: {
    padding: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#e1e1e1',
  },
  headerTitle: {
    fontSize: 24,
    fontWeight: 'bold',
  },
  section: {
    padding: 16,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    marginBottom: 16,
  },
});

export default WidgetSettings;
