import { useState, useCallback, useEffect } from 'react';
import WidgetDataManager from '../native/WidgetDataManager';

export type WidgetSettings = {
  isDarkMode: boolean;
  isNotificationEnabled: boolean;
  // 今後必要な設定項目をここに追加
};

export const useWidgetSettings = () => {
  const [settings, setSettings] = useState<WidgetSettings>({
    isDarkMode: false,
    isNotificationEnabled: false,
  });

  // 初期設定を読み込む
  useEffect(() => {
    const loadSettings = async () => {
      try {
        const savedSettings = await WidgetDataManager.getWidgetData();
        setSettings(savedSettings);
      } catch (error) {
        console.error('Failed to load widget settings:', error);
      }
    };

    loadSettings();
  }, []);

  // 設定を更新する
  const updateSetting = useCallback(async (
    key: keyof WidgetSettings,
    value: boolean
  ) => {
    try {
      const newSettings = {
        ...settings,
        [key]: value,
      };
      
      await WidgetDataManager.setWidgetData(newSettings);
      setSettings(newSettings);
      return true;
    } catch (error) {
      console.error('Failed to update widget settings:', error);
      return false;
    }
  }, [settings]);

  return {
    settings,
    updateSetting,
  };
};
