import Foundation
import Photos
import UIKit
import SwiftUI

enum DownloadError: Error, LocalizedError {
    case photoLibraryAccessDenied
    case invalidURL
    case downloadFailed
    case saveFailed
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .photoLibraryAccessDenied:
            return "写真へのアクセスが許可されていません"
        case .invalidURL:
            return "無効なURLです"
        case .downloadFailed:
            return "ダウンロードに失敗しました"
        case .saveFailed:
            return "保存に失敗しました"
        case .unknown:
            return "不明なエラーが発生しました"
        }
    }
}

@MainActor
class ContentDownloadManager: ObservableObject {
    static let shared = ContentDownloadManager()
    
    @Published var progress: Double = 0
    @Published var isDownloading = false
    @Published var errorMessage: String?
    
    private init() {}
    
    func downloadWallpaper(_ imageUrl: String) async throws {
        isDownloading = true
        progress = 0
        errorMessage = nil
        
        do {
            // 写真へのアクセス権限をチェック
            let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
            if status == .notDetermined {
                let granted = await PHPhotoLibrary.requestAuthorization(for: .addOnly) == .authorized
                if !granted {
                    throw DownloadError.photoLibraryAccessDenied
                }
            } else if status != .authorized {
                throw DownloadError.photoLibraryAccessDenied
            }
            
            guard let url = URL(string: imageUrl) else {
                throw DownloadError.invalidURL
            }
            
            // URLSessionを使用してダウンロード進捗を追跡
            let (data, response) = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<(Data, URLResponse), Error>) in
                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                          httpResponse.statusCode == 200,
                          let data = data else {
                        continuation.resume(throwing: DownloadError.downloadFailed)
                        return
                    }
                    
                    continuation.resume(returning: (data, httpResponse))
                }
                
                // 進捗監視
                let observation = task.progress.observe(\.fractionCompleted) { [weak self] progress, _ in
                    Task { @MainActor [weak self] in
                        self?.progress = progress.fractionCompleted
                    }
                }
                
                task.resume()
                
                // 観測オブジェクトを保持
                _ = observation
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let image = UIImage(data: data) else {
                throw DownloadError.downloadFailed
            }
            
            // 画像を保存
            try await PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }
            
            progress = 1.0
            isDownloading = false
        } catch {
            isDownloading = false
            
            if let downloadError = error as? DownloadError {
                errorMessage = downloadError.localizedDescription
            } else {
                errorMessage = DownloadError.unknown.localizedDescription
            }
            
            throw error
        }
    }
}
