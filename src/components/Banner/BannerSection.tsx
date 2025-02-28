import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { colors, spacing } from '../../styles/theme';

export const BannerSection: React.FC = () => {
  return (
    <View style={styles.container}>
      <Text style={styles.text}>広告・お知らせバナー</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    backgroundColor: colors.background,
    padding: spacing.md,
    marginVertical: spacing.sm,
    borderRadius: 8,
  },
  text: {
    textAlign: 'center',
  },
}); 