import { NativeModules } from 'react-native';

const { WidgetDataManager } = NativeModules;

interface WidgetData {
  isDarkMode: boolean;
  isNotificationEnabled: boolean;
}

export default {
  setWidgetData: (data: WidgetData): Promise<boolean> => {
    return WidgetDataManager.setWidgetData(data);
  },
  getWidgetData: (): Promise<WidgetData> => {
    return WidgetDataManager.getWidgetData();
  },
};
