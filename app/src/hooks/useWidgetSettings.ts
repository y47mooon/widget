import { useState, useCallback } from 'react';

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

  const updateSetting = useCallback(<K extends keyof WidgetSettings>(
    key: K,
    value: WidgetSettings[K]
  ) => {
    setSettings(prev => ({
      ...prev,
      [key]: value,
    }));
    // TODO: 設定を永続化する処理を追加
    // AsyncStorageなどを使用して保存
  }, []);

  return {
    settings,
    updateSetting,
  };
};
