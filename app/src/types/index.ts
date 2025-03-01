// Widget Settings
export type WidgetSettingsType = {
  isDarkMode: boolean;
  isNotificationEnabled: boolean;
};

// Widget Display Options
export type WidgetDisplayOptions = {
  backgroundColor: string;
  textColor: string;
  fontSize: number;
};

// Widget State
export type WidgetState = {
  isLoading: boolean;
  error: string | null;
  lastUpdated: Date | null;
};

// API Response Types (今後APIと通信する場合に使用)
export type ApiResponse<T> = {
  success: boolean;
  data?: T;
  error?: string;
};
