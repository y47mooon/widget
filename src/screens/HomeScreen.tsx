import React, { useState, useRef } from 'react';
import { View, ScrollView, StyleSheet } from 'react-native';
import { Logo } from '../components/Header/Logo';
import { TabMenu } from '../components/Header/TabMenu';
import { BannerSection } from '../components/Banner/BannerSection';
import { CategoryTags } from '../components/CategoryTags';
import { PopularHomeSection } from '../components/PopularSection/PopularHomeSection';
import { PopularWidgetSection } from '../components/PopularSection/PopularWidgetSection';
import { PopularLockSection } from '../components/PopularSection/PopularLockSection';
import { BottomNavigation } from '../components/BottomNavigation';
import { layoutStyles } from '../styles/common/layout';

const HomeScreen: React.FC = () => {
  const [activeTab, setActiveTab] = useState('全て');
  const [selectedTags, setSelectedTags] = useState<string[]>([]);
  
  // スクロール参照用
  const scrollViewRef = useRef<ScrollView>(null);
  
  // 各セクションの位置を保存
  const sectionRefs = {
    おしゃれ: useRef<View>(null),
    シンプル: useRef<View>(null),
    白: useRef<View>(null),
    モノクロ: useRef<View>(null),
    かわいい: useRef<View>(null),
    きれい: useRef<View>(null),
  };
  
  // タグをタップしたときの処理
  const handleTagPress = (tag: string) => {
    // タグに対応するセクションまでスクロール
    const ref = sectionRefs[tag as keyof typeof sectionRefs];
    if (ref.current) {
      ref.current.measureLayout(
        scrollViewRef.current?.getInnerViewNode() as any,
        (_, y) => {
          scrollViewRef.current?.scrollTo({ y, animated: true });
        },
        () => console.log('Failed to measure'),
      );
    }
    
    // タグの選択状態を更新
    if (selectedTags.includes(tag)) {
      setSelectedTags(selectedTags.filter(t => t !== tag));
    } else {
      setSelectedTags([...selectedTags, tag]);
    }
  };
  
  // タブをタップしたときの処理
  const handleTabPress = (tab: string) => {
    setActiveTab(tab);
    // タブに応じたコンテンツを表示（ここでは単純にタブを切り替えるだけ）
  };
  
  return (
    <View style={layoutStyles.container}>
      {/* ヘッダー部分 */}
      <View style={styles.header}>
        <Logo />
        <TabMenu activeTab={activeTab} onTabPress={handleTabPress} />
      </View>
      
      {/* メインコンテンツ */}
      <ScrollView 
        ref={scrollViewRef}
        style={styles.scrollView}
        showsVerticalScrollIndicator={false}
      >
        {/* 広告バナー */}
        <BannerSection />
        
        {/* カテゴリータグ */}
        <CategoryTags 
          tags={['おしゃれ', 'シンプル', '白', 'モノクロ', 'かわいい', 'きれい']}
          selectedTags={selectedTags}
          onTagPress={handleTagPress}
        />
        
        {/* 人気のホーム画面 */}
        <View ref={sectionRefs.おしゃれ}>
          <PopularHomeSection title="人気のホーム画面" />
        </View>
        
        {/* 人気のウィジェット */}
        <View ref={sectionRefs.シンプル}>
          <PopularWidgetSection title="人気のウィジェット" />
        </View>
        
        {/* 人気のロック画面 */}
        <View ref={sectionRefs.白}>
          <PopularLockSection title="人気のロック画面" />
        </View>
        
        {/* 必要に応じて追加のセクション */}
        <View ref={sectionRefs.モノクロ} />
        <View ref={sectionRefs.かわいい} />
        <View ref={sectionRefs.きれい} />
      </ScrollView>
      
      {/* 下部ナビゲーション */}
      <BottomNavigation 
        activeTab="ホーム"
        onTabPress={(tab) => console.log(`Pressed ${tab}`)}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  header: {
    paddingTop: 40, // ステータスバーの高さを考慮
  },
  scrollView: {
    flex: 1,
  },
});

export default HomeScreen; 