import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { colors, spacing, typography } from '../styles/theme';

interface BottomNavigationProps {
  activeTab: string;
  onTabPress: (tab: string) => void;
}

const tabs = [
  { id: 'home', label: 'ホーム', icon: '🏠' },
  { id: 'search', label: '検索', icon: '🔍' },
  { id: 'create', label: '作成', icon: '➕' },
  { id: 'favorites', label: 'お気に入り', icon: '❤️' },
  { id: 'profile', label: 'プロフィール', icon: '👤' },
];

export const BottomNavigation: React.FC<BottomNavigationProps> = ({ 
  activeTab, 
  onTabPress 
}) => {
  return (
    <View style={styles.container}>
      {tabs.map((tab) => (
        <TouchableOpacity
          key={tab.id}
          style={styles.tabButton}
          onPress={() => onTabPress(tab.id)}
        >
          <Text style={styles.tabIcon}>{tab.icon}</Text>
          <Text style={[
            styles.tabLabel,
            activeTab === tab.id && styles.activeTabLabel
          ]}>
            {tab.label}
          </Text>
        </TouchableOpacity>
      ))}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    alignItems: 'center',
    backgroundColor: colors.secondary,
    paddingVertical: spacing.sm,
    borderTopWidth: 1,
    borderTopColor: colors.border,
  },
  tabButton: {
    alignItems: 'center',
  },
  tabIcon: {
    fontSize: 24,
    marginBottom: spacing.xs / 2,
  },
  tabLabel: {
    fontSize: typography.fontSize.small,
    color: colors.text.secondary,
  },
  activeTabLabel: {
    color: colors.primary,
    fontWeight: '700',
  },
}); 