import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { colors, spacing, typography } from '../../styles/theme';

interface PopularSectionHeaderProps {
  title: string;
  onMorePress: () => void;
}

export const PopularSectionHeader: React.FC<PopularSectionHeaderProps> = ({ 
  title, 
  onMorePress 
}) => {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>{title}</Text>
      <TouchableOpacity onPress={onMorePress}>
        <Text style={styles.moreText}>もっと見る</Text>
      </TouchableOpacity>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.sm,
  },
  title: {
    fontSize: typography.fontSize.large,
    fontWeight: '700',
    color: colors.text.primary,
  },
  moreText: {
    fontSize: typography.fontSize.medium,
    color: colors.primary,
  },
}); 