import SwiftUI

struct MyPageListItem: View {
    let iconName: String
    let title: String
    let textColor: Color
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.system(size: 20))
                .frame(width: 24)
            Text(title)
                .foregroundColor(textColor)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct MyPageView: View {
    var body: some View {
        NavigationView {
            List {
                Group {
                    ZStack {
                        MyPageListItem(iconName: "cube.fill", title: "ダウンロード履歴", textColor: .primary)
                        NavigationLink(destination: Text("ダウンロード履歴")) {
                            EmptyView()
                        }
                        .opacity(0)
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .background(Color.white)
                
                Group {
                    ZStack {
                        MyPageListItem(iconName: "person.2.fill", title: "アカウント", textColor: .primary)
                        NavigationLink(destination: Text("アカウント設定")) {
                            EmptyView()
                        }
                        .opacity(0)
                    }
                    
                    ZStack {
                        MyPageListItem(iconName: "house.fill", title: "Fanlink (連携)", textColor: .primary)
                        NavigationLink(destination: Text("Fanlink設定")) {
                            EmptyView()
                        }
                        .opacity(0)
                    }
                    
                    ZStack {
                        MyPageListItem(iconName: "creditcard.fill", title: "決済情報", textColor: .primary)
                        NavigationLink(destination: Text("決済情報")) {
                            EmptyView()
                        }
                        .opacity(0)
                    }
                    
                    ZStack {
                        MyPageListItem(iconName: "bell.fill", title: "通知", textColor: .primary)
                        NavigationLink(destination: Text("通知設定")) {
                            EmptyView()
                        }
                        .opacity(0)
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .background(Color.white)
                
                Group {
                    ZStack {
                        MyPageListItem(iconName: "questionmark.circle.fill", title: "ヘルプ", textColor: .primary)
                        NavigationLink(destination: Text("ヘルプ")) {
                            EmptyView()
                        }
                        .opacity(0)
                    }
                    
                    ZStack {
                        MyPageListItem(iconName: "headphones", title: "お問い合わせ", textColor: .primary)
                        NavigationLink(destination: Text("お問い合わせ")) {
                            EmptyView()
                        }
                        .opacity(0)
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .background(Color.white)
                
                Button(action: {
                    // ログアウト処理
                    print("ログアウト")
                }) {
                    MyPageListItem(iconName: "rectangle.portrait.and.arrow.right", title: "ログアウト", textColor: .red)
                }
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .background(Color.white)
            }
            .listStyle(PlainListStyle())
        }
    }
}

#Preview {
    MyPageView()
}