import React from 'react';
import { View, Text, Switch, StyleSheet } from 'react-native';

type SettingItemProps = {
  label: string;
  value: boolean;
  onValueChange: (value: boolean) => void;
};

export const SettingItem: React.FC<SettingItemProps> = ({
  label,
  value,
  onValueChange,
}) => {
  return (
    <View style={styles.settingItem}>
      <Text style={styles.settingLabel}>{label}</Text>
      <Switch value={value} onValueChange={onValueChange} />
    </View>
  );
};

const styles = StyleSheet.create({
  settingItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingVertical: 8,
  },
  settingLabel: {
    fontSize: 16,
  },
});

export default SettingItem;
