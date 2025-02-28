import { StyleSheet } from 'react-native';
import { spacing } from '../theme';

export const layoutStyles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#FFFFFF',
  },
  section: {
    marginVertical: spacing.md,
  },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  column: {
    flexDirection: 'column',
  },
  // 他の共通レイアウトスタイル
}); 