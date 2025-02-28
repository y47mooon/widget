import { StyleSheet } from 'react-native';
import { colors, spacing, typography } from '../theme';

export const headerStyles = StyleSheet.create({
  container: {
    backgroundColor: colors.secondary,
    paddingVertical: spacing.md,
    borderBottomWidth: 1,
    borderBottomColor: colors.border,
  },
  logo: {
    alignItems: 'center',
    marginBottom: spacing.sm,
  },
  tabContainer: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    paddingHorizontal: spacing.md,
  },
  tab: {
    paddingVertical: spacing.xs,
  },
  tabText: {
    fontSize: typography.fontSize.medium,
    color: colors.text.secondary,
  },
  activeTab: {
    borderBottomWidth: 2,
    borderBottomColor: colors.primary,
  },
  activeTabText: {
    color: colors.primary,
    fontWeight: '700',
  },
}); 