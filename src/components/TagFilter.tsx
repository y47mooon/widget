import React from 'react';
import { View, Text, TouchableOpacity } from 'react-native';
import { tagFilterStyles } from '../styles/components/tagFilter';

interface TagFilterProps {
  tags: string[];
  selectedTags: string[];
  onTagPress: (tag: string) => void;
}

export const TagFilter: React.FC<TagFilterProps> = ({ 
  tags, 
  selectedTags, 
  onTagPress 
}) => {
  return (
    <View style={tagFilterStyles.container}>
      {tags.map((tag) => (
        <TouchableOpacity
          key={tag}
          style={[
            tagFilterStyles.tag,
            selectedTags.includes(tag) && tagFilterStyles.tagSelected,
          ]}
          onPress={() => onTagPress(tag)}
        >
          <Text style={[
            tagFilterStyles.tagText,
            selectedTags.includes(tag) && tagFilterStyles.tagTextSelected,
          ]}>
            {tag}
          </Text>
        </TouchableOpacity>
      ))}
    </View>
  );
}; 