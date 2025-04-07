public enum SharedConstants {
    public enum UserDefaults {
        public static let appGroupID = "group.gaudiy.widgetoshinoko"
        public static let clockPresetKey = "clock_presets"
        public static let cachedContentsKey = "cached_contents"
        public static let customWidgetsKey = "custom_widgets"
    }
    
    public enum Layout {
        public static let defaultFontSize: Double = 14.0
        public static let defaultPadding: Double = 16.0
    }
}

public enum Constants {
    public static let appGroupID = SharedConstants.UserDefaults.appGroupID
    public static let clockPresetKey = SharedConstants.UserDefaults.clockPresetKey
}
