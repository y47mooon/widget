import React from 'react';
import { View, Text, Image, ScrollView, TouchableOpacity, StyleSheet } from 'react-native';
import { PopularSectionHeader } from './PopularSectionHeader';
import { colors, spacing, layout, typography } from '../../styles/theme';

interface PopularLockSectionProps {
  title: string;
}

const popularLockItems = [
  { id: '1', image: 'https://via.placeholder.com/150', title: 'ロック画面1' },
  { id: '2', image: 'https://via.placeholder.com/150', title: 'ロック画面2' },
  { id: '3', image: 'https://via.placeholder.com/150', title: 'ロック画面3' },
  { id: '4', image: 'https://via.placeholder.com/150', title: 'ロック画面4' },
];

export const PopularLockSection: React.FC<PopularLockSectionProps> = ({ title }) => {
  return (
    <View style={styles.container}>
      <PopularSectionHeader 
        title={title} 
        onMorePress={() => console.log('More pressed')} 
      />
      <ScrollView 
        horizontal 
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={styles.scrollContent}
      >
        {popularLockItems.map((item) => (
          <TouchableOpacity key={item.id} style={styles.itemContainer}>
            <Image 
              source={{ uri: item.image }} 
              style={styles.image} 
              resizeMode="cover"
            />
            <Text style={styles.itemTitle}>{item.title}</Text>
          </TouchableOpacity>
        ))}
      </ScrollView>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    marginVertical: spacing.md,
  },
  scrollContent: {
    paddingHorizontal: spacing.md,
  },
  itemContainer: {
    marginRight: spacing.md,
    width: 150,
  },
  image: {
    width: 150,
    height: 250,
    borderRadius: layout.borderRadius.medium,
  },
  itemTitle: {
    marginTop: spacing.xs,
    fontSize: typography.fontSize.small,
    textAlign: 'center',
  },
}); 