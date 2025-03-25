import Foundation
import FirebaseFirestore
import FirebaseAuth

protocol FirestoreRepositoryProtocol {
    // コンテンツ関連
    func fetchContents(category: String, limit: Int) async throws -> [ContentItem]
    func saveContent(_ content: ContentItem) async throws
    func updateContent(_ content: ContentItem) async throws
    func deleteContent(id: String) async throws
    
    // ユーザー関連
    func fetchCurrentUser() async throws -> User?
    func createUser(email: String, password: String) async throws -> User
    func signIn(email: String, password: String) async throws -> User
    func signOut() async throws
    
    // ユーザーコンテンツ関連
    func fetchUserContents(userId: String) async throws -> [UserContent]
    func saveUserContent(_ userContent: UserContent) async throws
    
    // 支払い関連
    func fetchPayments(userId: String) async throws -> [Payment]
    func savePayment(_ payment: Payment) async throws
}

class FirestoreRepository: FirestoreRepositoryProtocol {
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    // コレクション名の定義
    private enum Collection {
        static let contents = "contents"
        static let users = "users"
        static let admins = "admins"
        static let userContents = "user_contents"
        static let payments = "payments"
    }
    
    // コンテンツ関連
    func fetchContents(category: String, limit: Int) async throws -> [ContentItem] {
        let query = db.collection(Collection.contents)
            .whereField("content_type", isEqualTo: category)
            .limit(to: limit)
        
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap { document in
            do {
                return try document.data(as: ContentItem.self)
            } catch {
                print("ドキュメント変換エラー: \(error)")
                return nil
            }
        }
    }
    
    func saveContent(_ content: ContentItem) async throws {
        let documentRef = db.collection(Collection.contents).document(content.id.uuidString)
        try documentRef.setData(from: content)
    }
    
    func updateContent(_ content: ContentItem) async throws {
        let documentRef = db.collection(Collection.contents).document(content.id.uuidString)
        try documentRef.setData(from: content, merge: true)
    }
    
    func deleteContent(id: String) async throws {
        try await db.collection(Collection.contents).document(id).delete()
    }
    
    // ユーザー関連
    func fetchCurrentUser() async throws -> User? {
        guard let authUser = auth.currentUser else {
            return nil
        }
        
        let documentRef = db.collection(Collection.users).document(authUser.uid)
        let document = try await documentRef.getDocument()
        
        if document.exists {
            return try document.data(as: User.self)
        }
        return nil
    }
    
    func createUser(email: String, password: String) async throws -> User {
        let result = try await auth.createUser(withEmail: email, password: password)
        let newUser = User(
            id: result.user.uid,
            externalUserId: result.user.uid,
            email: email,
            membershipStatus: "free",
            createdAt: Date()
        )
        
        let documentRef = db.collection(Collection.users).document(result.user.uid)
        try documentRef.setData(from: newUser)
        
        return newUser
    }
    
    func signIn(email: String, password: String) async throws -> User {
        let result = try await auth.signIn(withEmail: email, password: password)
        
        let documentRef = db.collection(Collection.users).document(result.user.uid)
        let document = try await documentRef.getDocument()
        
        if document.exists {
            return try document.data(as: User.self)
        } else {
            // ユーザードキュメントが存在しない場合は作成
            let newUser = User(
                id: result.user.uid,
                externalUserId: result.user.uid,
                email: email,
                membershipStatus: "free",
                createdAt: Date()
            )
            
            try documentRef.setData(from: newUser)
            return newUser
        }
    }
    
    func signOut() async throws {
        try auth.signOut()
    }
    
    // ユーザーコンテンツ関連
    func fetchUserContents(userId: String) async throws -> [UserContent] {
        let query = db.collection(Collection.userContents)
            .whereField("user_id", isEqualTo: userId)
        
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap { document in
            try? document.data(as: UserContent.self)
        }
    }
    
    func saveUserContent(_ userContent: UserContent) async throws {
        let documentRef = db.collection(Collection.userContents).document(userContent.id.uuidString)
        try documentRef.setData(from: userContent)
    }
    
    // 支払い関連
    func fetchPayments(userId: String) async throws -> [Payment] {
        let query = db.collection(Collection.payments)
            .whereField("user_id", isEqualTo: userId)
        
        let snapshot = try await query.getDocuments()
        return snapshot.documents.compactMap { document in
            try? document.data(as: Payment.self)
        }
    }
    
    func savePayment(_ payment: Payment) async throws {
        let documentRef = db.collection(Collection.payments).document(payment.id.uuidString)
        try documentRef.setData(from: payment)
    }
}
