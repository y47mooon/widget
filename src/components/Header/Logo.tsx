import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { colors, typography } from '../../styles/theme';

export const Logo: React.FC = () => {
  return (
    <View style={styles.container}>
      <Text style={styles.logoText}>Logo</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    padding: 10,
  },
  logoText: {
    fontSize: typography.fontSize.xlarge,
    fontWeight: '700',
    color: colors.text.primary,
  },
}); 