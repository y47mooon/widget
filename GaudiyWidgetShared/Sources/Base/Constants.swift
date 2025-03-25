public enum SharedConstants {
    public enum UserDefaults {
        public static let appGroupID = "group.gaudy.widgetoshinoko"
        public static let clockPresetKey = "selectedClockPreset"
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
