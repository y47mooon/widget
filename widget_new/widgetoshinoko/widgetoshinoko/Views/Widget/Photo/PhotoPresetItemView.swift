import SwiftUI

struct PhotoPresetItemView: View {
    let widget: WidgetItem
    @State private var showPreview = false
    
    var body: some View {
        Button(action: {
            showPreview = true
        }) {
            HStack {
                // 左側に写真アイコン
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                    
                    Image(systemName: "photo")
                        .font(.system(size: 30))
                        .foregroundColor(.purple)
                }
                
                // テキスト情報
                VStack(alignment: .leading, spacing: 4) {
                    Text(widget.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("お気に入りの写真を表示")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .padding(.leading, 8)
                
                Spacer()
                
                // 右端に矢印アイコン
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 1)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showPreview) {
            PhotoPreviewView(title: widget.title)
        }
    }
}

struct PhotoPreviewView: View {
    let title: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            // ヘッダー
            HStack {
                Text("プレビュー")
                    .font(.headline)
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            
            // プレビュー内容（ここではプレースホルダー画像を表示）
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(maxWidth: .infinity)
                    .frame(height: 300)
                
                VStack {
                    Image(systemName: "photo")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    
                    Text("画像をタップして選択")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                }
            }
            .cornerRadius(12)
            .padding(.horizontal)
            
            // 統計情報
            HStack(spacing: 20) {
                HStack {
                    Image(systemName: "eye")
                    Text("1000")
                }
                .foregroundColor(.gray)
                
                HStack {
                    Image(systemName: "heart")
                    Text("500")
                }
                .foregroundColor(.gray)
            }
            
            // タイトルと説明
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title2)
                    .bold()
                
                Text("お気に入りの写真をウィジェットとして表示できます")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            
            Spacer()
            
            // 設定ボタン
            Button(action: {
                // 設定アクション
            }) {
                Text("設定")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
    }
}
