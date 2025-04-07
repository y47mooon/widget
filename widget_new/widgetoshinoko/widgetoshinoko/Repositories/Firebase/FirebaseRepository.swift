import Foundation
import GaudiyWidgetShared

#if canImport(FirebaseFirestore)
import FirebaseFirestore
import FirebaseAuth
#endif

// 型の曖昧さを回避するためにFirebaseAuth.Userと区別するエイリアス
typealias AppUser = GaudiyWidgetShared.User

#if canImport(FirebaseFirestore)
class FirestoreRepository: FirestoreRepositoryProtocol {
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    // コレクション名の定義
    private enum Collection {
        static let contents = "contents"
        static let users = "users"
        static let userContents = "user_contents"
        static let payments = "payments"
    }
    
    // MARK: - コンテンツ関連
    func fetchContents(category: String, limit: Int) async throws -> [FirebaseContentItem] {
        Logger.shared.info("Fetching contents - category: \(category), limit: \(limit)")
        let collectionRef = db.collection(Collection.contents)
        var query: Query = collectionRef
        
        if !category.isEmpty {
            query = query.whereField("contentType", isEqualTo: category)
        }
        
        // limitを適用
        query = query.limit(to: limit)
        
        let snapshot = try await query.getDocuments()
        Logger.shared.debug("Found \(snapshot.documents.count) documents")
        
        let contents = snapshot.documents.compactMap { document -> FirebaseContentItem? in
            print("📙 Processing document: \(document.documentID)")
            let data = document.data()
            guard let type = data["type"] as? String,
                  let contentType = data["contentType"] as? String else {
                return nil
            }
            
            // データを変換
            var contentData: [String: AnyCodable] = [:]
            for (key, value) in data {
                if key != "id" && key != "type" && key != "contentType" {
                    contentData[key] = AnyCodable(value)
                }
            }
            
            return FirebaseContentItem(
                id: document.documentID,
                type: type,
                contentType: contentType, 
                data: contentData
            )
        }
        
        print("📕 Successfully converted \(contents.count) items")
        
        // ウィジェット用にキャッシュ
        WidgetDataService.shared.cacheContents(contents)
        
        return contents
    }
    
    func saveContent(_ content: FirebaseContentItem) async throws {
        let documentRef = db.collection(Collection.contents).document(content.id)
        
        // 手動でデータをエンコード
        var data: [String: Any] = [
            "type": content.type,
            "contentType": content.contentType
        ]
        
        // データを追加 - エラー修正: Initializer for conditional binding must have Optional type, not 'Any'
        for (key, value) in content.data {
            // unwrappedValueをOptionalとして扱わない
            data[key] = value.value
        }
        
        try await documentRef.setData(data)
    }
    
    func updateContent(_ content: FirebaseContentItem) async throws {
        let documentRef = db.collection(Collection.contents).document(content.id)
        
        // 手動でデータをエンコード
        var data: [String: Any] = [
            "type": content.type,
            "contentType": content.contentType
        ]
        
        // データを追加 - エラー修正: Initializer for conditional binding must have Optional type, not 'Any'
        for (key, value) in content.data {
            // unwrappedValueをOptionalとして扱わない
            data[key] = value.value
        }
        
        try await documentRef.updateData(data)
    }
    
    func deleteContent(id: String) async throws {
        try await db.collection(Collection.contents).document(id).delete()
    }
    
    // MARK: - ユーザー関連
    func fetchCurrentUser() async throws -> AppUser? {
        guard let authUser = auth.currentUser else {
            return nil
        }
        
        let documentRef = db.collection(Collection.users).document(authUser.uid)
        let document = try await documentRef.getDocument()
        
        if document.exists {
            // 手動デコード
            let data = document.data() ?? [:]
            guard let name = data["name"] as? String else {
                return nil
            }
            
            return AppUser(
                id: authUser.uid,
                name: name
            )
        }
        
        return nil
    }
    
    func createUser(email: String, password: String) async throws -> AppUser {
        let authResult = try await auth.createUser(withEmail: email, password: password)
        let user = authResult.user
        
        // ユーザープロファイルを作成
        let userData: [String: Any] = [
            "id": user.uid,
            "name": email.components(separatedBy: "@").first ?? "User"
        ]
        
        // Firestoreにユーザー情報を保存
        try await db.collection(Collection.users).document(user.uid).setData(userData)
        
        return AppUser(
            id: user.uid,
            name: userData["name"] as! String
        )
    }
    
    func signIn(email: String, password: String) async throws -> AppUser {
        let authResult = try await auth.signIn(withEmail: email, password: password)
        let user = authResult.user
        
        // Firestoreからユーザー情報を取得
        let documentRef = db.collection(Collection.users).document(user.uid)
        let document = try await documentRef.getDocument()
        
        if document.exists, let data = document.data() {
            let name = data["name"] as? String ?? email.components(separatedBy: "@").first ?? "User"
            
            return AppUser(
                id: user.uid,
                name: name
            )
        } else {
            // ユーザー情報がない場合は新規作成
            let userData: [String: Any] = [
                "id": user.uid,
                "name": email.components(separatedBy: "@").first ?? "User"
            ]
            
            try await documentRef.setData(userData)
            
            return AppUser(
                id: user.uid,
                name: userData["name"] as! String
            )
        }
    }
    
    func signOut() async throws {
        try auth.signOut()
    }
    
    // MARK: - ユーザーコンテンツ関連
    func fetchUserContents(userId: String) async throws -> [UserContent] {
        let snapshot = try await db.collection(Collection.userContents)
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        
        // UserContentのモデル定義を確認し、適切にマッピング
        // エラー修正: Extra argument 'type' in call
        return snapshot.documents.compactMap { document -> UserContent? in
            let data = document.data()
            guard let contentId = data["contentId"] as? String,
                  let userId = data["userId"] as? String else {
                return nil
            }
            
            // 'type'引数を削除してUserContentを初期化
            return UserContent(
                userId: userId,
                contentId: contentId
            )
        }
    }
    
    func saveUserContent(_ userContent: UserContent) async throws {
        // UserContentにidがない場合は一意のIDを生成
        let documentId = "\(userContent.userId)_\(userContent.contentId)"
        let documentRef = db.collection(Collection.userContents).document(documentId)
        
        // 手動でデータをエンコード
        // エラー修正: Value of type 'UserContent' has no member 'type'
        let data: [String: Any] = [
            "contentId": userContent.contentId,
            "userId": userContent.userId
            // typeプロパティを削除
        ]
        
        try await documentRef.setData(data)
    }
    
    // MARK: - 支払い関連
    func fetchPayments(userId: String) async throws -> [Payment] {
        let snapshot = try await db.collection(Collection.payments)
            .whereField("userId", isEqualTo: userId)
            .getDocuments()
        
        // Paymentモデルをマッピング
        return snapshot.documents.compactMap { document -> Payment? in
            let data = document.data()
            guard let userId = data["userId"] as? String,
                  let productId = data["productId"] as? String,
                  let amount = data["amount"] as? Double,
                  let currency = data["currency"] as? String,
                  let statusRaw = data["status"] as? String,
                  let status = PaymentStatus(rawValue: statusRaw) else {
                return nil
            }
            
            // UUIDの生成
            let uuid = UUID(uuidString: document.documentID) ?? UUID()
            
            return Payment(
                id: uuid,
                userId: userId,
                productId: productId,
                amount: amount,
                currency: currency,
                status: status,
                createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                updatedAt: (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
            )
        }
    }
    
    func savePayment(_ payment: Payment) async throws {
        let documentRef = db.collection(Collection.payments).document(payment.id.uuidString)
        
        // 手動でデータをエンコード
        let data: [String: Any] = [
            "userId": payment.userId,
            "productId": payment.productId,
            "amount": payment.amount,
            "currency": payment.currency,
            "status": payment.status.rawValue,
            "createdAt": Timestamp(date: payment.createdAt),
            "updatedAt": Timestamp(date: payment.updatedAt)
        ]
        
        try await documentRef.setData(data)
    }
}
#endif
