import React from 'react';
import { View, Text, TouchableOpacity, ScrollView } from 'react-native';
import { headerStyles } from '../../styles/components/header';

interface TabMenuProps {
  activeTab: string;
  onTabPress: (tab: string) => void;
}

const tabs = ['全て', 'テンプレート', 'ウィジェット', 'アイコン', '壁紙', 'ロック画面', '動く画面'];

export const TabMenu: React.FC<TabMenuProps> = ({ activeTab, onTabPress }) => {
  return (
    <ScrollView 
      horizontal 
      showsHorizontalScrollIndicator={false}
      contentContainerStyle={headerStyles.tabContainer}
    >
      {tabs.map((tab) => (
        <TouchableOpacity
          key={tab}
          style={[
            headerStyles.tab,
            activeTab === tab && headerStyles.activeTab
          ]}
          onPress={() => onTabPress(tab)}
        >
          <Text style={[
            headerStyles.tabText,
            activeTab === tab && headerStyles.activeTabText
          ]}>
            {tab}
          </Text>
        </TouchableOpacity>
      ))}
    </ScrollView>
  );
}; 