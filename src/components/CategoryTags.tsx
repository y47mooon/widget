import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { colors, spacing, typography } from '../styles/theme';

interface CategoryTagsProps {
  tags: string[];
  selectedTags: string[];
  onTagPress: (tag: string) => void;
}

export const CategoryTags: React.FC<CategoryTagsProps> = ({ 
  tags, 
  selectedTags, 
  onTagPress 
}) => {
  return (
    <View style={styles.container}>
      {tags.map((tag) => (
        <TouchableOpacity
          key={tag}
          style={[
            styles.tag,
            selectedTags.includes(tag) && styles.tagSelected,
          ]}
          onPress={() => onTagPress(tag)}
        >
          <Text style={[
            styles.tagText,
            selectedTags.includes(tag) && styles.tagTextSelected,
          ]}>
            {tag}
          </Text>
        </TouchableOpacity>
      ))}
    </View>
  );
};

const styles = StyleSheet.create({
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