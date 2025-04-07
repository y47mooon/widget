import SwiftUI

struct MemoPresetItemView: View {
    let widget: WidgetItem
    @State private var showPreview = false
    
    var body: some View {
        Button(action: {
            showPreview = true
        }) {
            HStack {
                // 左側にメモアイコン
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                    
                    VStack {
                        Image(systemName: "note.text")
                            .font(.system(size: 30))
                            .foregroundColor(.orange)
                    }
                }
                
                // テキスト情報
                VStack(alignment: .leading, spacing: 4) {
                    Text(widget.title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("メモを表示するウィジェット")
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
            MemoPreviewView(title: widget.title)
        }
    }
}

struct MemoPreviewView: View {
    let title: String
    @State private var memoText = "ここにメモを入力してください。\nタスク:\n・買い物に行く\n・会議の準備\n・資料作成"
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
            
            // プレビュー内容
            ZStack {
                Rectangle()
                    .fill(Color(UIColor.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("メモ")
                        .font(.headline)
                        .foregroundColor(.orange)
                    
                    TextEditor(text: $memoText)
                        .frame(height: 200)
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(8)
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
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
                
                Text("メモやToDoリストを表示できるウィジェットです")
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
