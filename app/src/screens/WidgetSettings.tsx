import React from 'react';
import { SafeAreaView, ScrollView, View, Text, StyleSheet, useColorScheme } from 'react-native';
import { SettingItem } from '../components/SettingItem';
import { useWidgetSettings } from '../hooks/useWidgetSettings';

export const WidgetSettings: React.FC = () => {
  const isDarkMode = useColorScheme() === 'dark';
  const { settings, updateSetting } = useWidgetSettings();

  return (
    <SafeAreaView style={styles.container}>
      <ScrollView>
        <View style={styles.header}>
          <Text style={styles.title}>Widget Settings</Text>
        </View>
        
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Display Options</Text>
          <SettingItem
            label="Enable Dark Mode"
            value={settings.isDarkMode}
            onValueChange={(value) => updateSetting('isDarkMode', value)}
          />
          <SettingItem
            label="Enable Notifications"
            value={settings.isNotificationEnabled}
            onValueChange={(value) => updateSetting('isNotificationEnabled', value)}
          />
        </View>
      </ScrollView>
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
    borderBottomColor: '#eee',
  },
  title: {
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
