import Foundation

enum RepositoryType {
    case mock
    case userDefaults
    case firebase
}

class RepositoryFactory {
    static let shared = RepositoryFactory()
    
    private init() {}
    
    // 設定（プロダクション環境ではfirebaseを使用）
    #if DEBUG
    private var defaultType: RepositoryType = .firebase
    #else
    private var defaultType: RepositoryType = .firebase
    #endif
    
    func setDefaultType(_ type: RepositoryType) {
        defaultType = type
    }
    
    func makeClockPresetRepository() -> ClockPresetRepository {
        switch defaultType {
        case .mock:
            return MockClockPresetRepository()
        case .userDefaults:
            return ClockPresetRepositoryImpl()
        case .firebase:
            return FirebaseClockPresetRepository()
        }
    }
    
    func makeFirestoreRepository() -> FirestoreRepositoryProtocol {
        return FirestoreRepository()
    }
}
