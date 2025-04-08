import Foundation
import Photos
import UIKit
import SwiftUI

enum DownloadError: Error, LocalizedError {
    case photoLibraryAccessDenied
    case invalidURL
    case downloadFailed
    case saveFailed
    case cancelled
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
        case .cancelled:
            return "ダウンロードがキャンセルされました"
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
    
    private var currentTask: URLSessionDataTask?
    private var progressObservation: NSKeyValueObservation?
    
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
                let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                    // タスク参照をクリア
                    self?.currentTask = nil
                    self?.progressObservation = nil
                    
                    if let error = error {
                        if (error as NSError).domain == NSURLErrorDomain && 
                           (error as NSError).code == NSURLErrorCancelled {
                            continuation.resume(throwing: DownloadError.cancelled)
                        } else {
                            continuation.resume(throwing: error)
                        }
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
                
                // 現在のタスクを保存
                self.currentTask = task
                
                // 進捗監視
                self.progressObservation = task.progress.observe(\.fractionCompleted) { [weak self] progress, _ in
                    Task { @MainActor [weak self] in
                        self?.progress = progress.fractionCompleted
                    }
                }
                
                task.resume()
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
    
    /// 現在進行中のダウンロードをキャンセルする
    func cancelDownload() {
        if let task = currentTask, task.state == .running {
            task.cancel()
        }
        
        // 状態をリセット
        Task { @MainActor in
            self.isDownloading = false
            self.progress = 0
            self.errorMessage = DownloadError.cancelled.localizedDescription
            self.currentTask = nil
            self.progressObservation?.invalidate()
            self.progressObservation = nil
        }
    }
}
