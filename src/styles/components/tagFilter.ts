import { StyleSheet } from 'react-native';
import { colors, spacing, typography } from '../theme';

export const tagFilterStyles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    padding: spacing.md,
    gap: spacing.sm,
  },
  tag: {
    paddingHorizontal: spacing.md,
    paddingVertical: spacing.xs,
    borderRadius: 20,
    borderWidth: 1,
    borderColor: colors.primary,
  },
  tagText: {
    fontSize: typography.fontSize.medium,
    color: colors.primary,
  },
  tagSelected: {
    backgroundColor: colors.primary,
  },
  tagTextSelected: {
    color: colors.secondary,
  },
}); 