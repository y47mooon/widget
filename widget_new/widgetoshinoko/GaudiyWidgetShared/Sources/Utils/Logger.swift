import OSLog

public struct Logger {
    public static let shared = Logger()
    private let logger = os.Logger(subsystem: "com.gaudiy.widget", category: "Content")
    
    public func debug(_ message: String) {
        #if DEBUG
        logger.debug("🔍 \(message)")
        #endif
    }
    
    public func info(_ message: String) {
        logger.info("ℹ️ \(message)")
    }
    
    public func error(_ message: String, error: Error? = nil) {
        if let error = error {
            logger.error("❌ \(message): \(error.localizedDescription)")
        } else {
            logger.error("❌ \(message)")
        }
    }
}
