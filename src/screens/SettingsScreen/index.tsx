import React, { useState, useRef } from 'react';
import {
  View,
  Text,
  ScrollView,
  SafeAreaView,
  StyleSheet,
  Dimensions,
  Animated,
  Pressable,
  useWindowDimensions,
} from 'react-native';

type TabType = '全て' | 'テンプレート' | 'ウィジェット' | 'アイコン' | '壁紙' | 'ロック';
type ThemeTagType = 'おしゃれ' | 'シンプル' | '白' | 'モノクロ' | 'かわいい' | 'きれい';

const SettingsScreen: React.FC = () => {
  const { width } = useWindowDimensions();
  const [activeTab, setActiveTab] = useState<TabType>('全て');
  const [selectedThemes, setSelectedThemes] = useState<ThemeTagType[]>([]);
  const scrollViewRef = useRef<ScrollView>(null);
  const tabScrollViewRef = useRef<ScrollView>(null);

  const tabs: TabType[] = ['全て', 'テンプレート', 'ウィジェット', 'アイコン', '壁紙', 'ロック'];
  const themeTags: ThemeTagType[] = ['おしゃれ', 'シンプル', '白', 'モノクロ', 'かわいい', 'きれい'];

  const handleTabPress = (tab: TabType, index: number) => {
    setActiveTab(tab);
    // タブが押されたら、そのタブが見えるように自動スクロール
    tabScrollViewRef.current?.scrollTo({
      x: index * (width / 4) - width / 3,
      animated: true
    });
  };

  return (
    <SafeAreaView style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <Text style={styles.logo}>Logo</Text>
      </View>

      {/* Tab Navigation */}
      <ScrollView 
        ref={tabScrollViewRef}
        horizontal 
        showsHorizontalScrollIndicator={false}
        style={styles.tabContainer}
        contentContainerStyle={styles.tabContentContainer}
      >
        {tabs.map((tab, index) => (
          <Pressable 
            key={tab}
            style={({ pressed }) => [
              styles.tab,
              activeTab === tab && styles.activeTab,
              pressed && styles.pressedTab
            ]}
            onPress={() => handleTabPress(tab, index)}
            accessible={true}
            accessibilityRole="tab"
            accessibilityState={{ selected: activeTab === tab }}
            accessibilityLabel={`${tab}タブ`}
          >
            <Text 
              style={[
                styles.tabText,
                activeTab === tab && styles.activeTabText
              ]}
            >
              {tab}
            </Text>
          </Pressable>
        ))}
      </ScrollView>

      {/* Theme Tags */}
      <ScrollView 
        ref={scrollViewRef}
        horizontal 
        showsHorizontalScrollIndicator={false}
        style={styles.themeContainer}
        contentContainerStyle={styles.themeContentContainer}
      >
        {themeTags.map((theme) => (
          <Pressable 
            key={theme}
            style={({ pressed }) => [
              styles.themeTag,
              selectedThemes.includes(theme) && styles.activeThemeTag,
              pressed && styles.pressedThemeTag
            ]}
            onPress={() => {
              if (selectedThemes.includes(theme)) {
                setSelectedThemes(selectedThemes.filter(t => t !== theme));
              } else {
                setSelectedThemes([...selectedThemes, theme]);
              }
            }}
            accessible={true}
            accessibilityRole="button"
            accessibilityState={{ selected: selectedThemes.includes(theme) }}
            accessibilityLabel={`${theme}タグ`}
          >
            <Text 
              style={[
                styles.themeText,
                selectedThemes.includes(theme) && styles.activeThemeText
              ]}
            >
              {theme}
            </Text>
          </Pressable>
        ))}
      </ScrollView>

      {/* Preview Area */}
      <ScrollView 
        style={styles.previewContainer}
        contentContainerStyle={styles.previewContentContainer}
      >
        <Text style={styles.sectionTitle}>人気のホーム画面</Text>
        {/* PreviewCard component will be added here */}
      </ScrollView>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  header: {
    height: 44,
    justifyContent: 'center',
    alignItems: 'center',
    borderBottomWidth: 1,
    borderBottomColor: '#f0f0f0',
    backgroundColor: '#fff',
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 2,
  },
  logo: {
    fontSize: 18,
    fontWeight: 'bold',
  },
  tabContainer: {
    flexGrow: 0,
    height: 44,
    borderBottomWidth: 1,
    borderBottomColor: '#f0f0f0',
    backgroundColor: '#fff',
  },
  tabContentContainer: {
    paddingHorizontal: 16,
  },
  tab: {
    paddingHorizontal: 16,
    height: '100%',
    justifyContent: 'center',
    alignItems: 'center',
  },
  activeTab: {
    borderBottomWidth: 2,
    borderBottomColor: '#E91E63',
  },
  pressedTab: {
    opacity: 0.7,
  },
  tabText: {
    fontSize: 14,
    color: '#666',
  },
  activeTabText: {
    color: '#E91E63',
    fontWeight: '600',
  },
  themeContainer: {
    flexGrow: 0,
    height: 40,
    backgroundColor: '#fff',
  },
  themeContentContainer: {
    paddingHorizontal: 16,
    paddingVertical: 8,
  },
  themeTag: {
    paddingHorizontal: 16,
    paddingVertical: 6,
    borderRadius: 16,
    backgroundColor: '#f5f5f5',
    marginRight: 8,
    borderWidth: 1,
    borderColor: '#f0f0f0',
  },
  activeThemeTag: {
    backgroundColor: '#FFE5EE',
    borderColor: '#E91E63',
  },
  pressedThemeTag: {
    opacity: 0.7,
  },
  themeText: {
    fontSize: 13,
    color: '#666',
  },
  activeThemeText: {
    color: '#E91E63',
  },
  previewContainer: {
    flex: 1,
    backgroundColor: '#fff',
  },
  previewContentContainer: {
    padding: 16,
  },
  sectionTitle: {
    fontSize: 16,
    fontWeight: '600',
    marginBottom: 12,
  },
});

export default SettingsScreen; 