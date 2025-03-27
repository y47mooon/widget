import Foundation
import SwiftUI
import GaudiyWidgetShared
import Combine

@MainActor
class AppViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let firestoreRepository: FirestoreRepositoryProtocol
    
    init(repository: FirestoreRepositoryProtocol = RepositoryFactory.shared.makeFirestoreRepository()) {
        self.firestoreRepository = repository
        
        // 起動時に認証状態を確認
        Task {
            await checkAuthStatus()
        }
    }
    
    private func checkAuthStatus() async {
        isLoading = true
        
        do {
            if let user = try await firestoreRepository.fetchCurrentUser() {
                currentUser = user
                isAuthenticated = true
            } else {
                currentUser = nil
                isAuthenticated = false
            }
        } catch {
            errorMessage = "認証情報の取得に失敗しました"
            print("認証エラー: \(error)")
        }
        
        isLoading = false
    }
    
    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await firestoreRepository.signIn(email: email, password: password)
            currentUser = user
            isAuthenticated = true
        } catch {
            errorMessage = "ログインに失敗しました"
            print("ログインエラー: \(error)")
        }
        
        isLoading = false
    }
    
    func signUp(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let user = try await firestoreRepository.createUser(email: email, password: password)
            currentUser = user
            isAuthenticated = true
        } catch {
            errorMessage = "アカウント作成に失敗しました"
            print("登録エラー: \(error)")
        }
        
        isLoading = false
    }
    
    func signOut() async {
        isLoading = true
        
        do {
            try await firestoreRepository.signOut()
            currentUser = nil
            isAuthenticated = false
        } catch {
            errorMessage = "ログアウトに失敗しました"
            print("ログアウトエラー: \(error)")
        }
        
        isLoading = false
    }
}
