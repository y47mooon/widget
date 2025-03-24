import SwiftUI

struct MyPageListItem: View {
    let iconName: String
    let title: String
    var textColor: Color = .black
    var showChevron: Bool = true
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.system(size: 20))
                .foregroundColor(textColor)
                .frame(width: 24, height: 24)
            
            Text(title)
                .foregroundColor(textColor)
            
            Spacer()
            
            if showChevron && textColor != .red {
                Image(systemName: "chevron.forward")
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
            }
        }
        .padding(.vertical, 12)
    }
}

struct MyPageView: View {
    var body: some View {
        NavigationView {
            List {
                Group {
                    NavigationLink {
                        DownloadHistoryView()
                    } label: {
                        MyPageListItem(
                            iconName: "square.and.arrow.down",
                            title: "mypage_download_history".localized,
                            showChevron: false
                        )
                    }
                    
                    NavigationLink {
                        AccountView()
                    } label: {
                        MyPageListItem(
                            iconName: "person.2",
                            title: "mypage_account".localized,
                            showChevron: false
                        )
                    }
                    
                    NavigationLink {
                        FanlinkView()
                    } label: {
                        MyPageListItem(
                            iconName: "house",
                            title: "mypage_fanlink".localized,
                            showChevron: false
                        )
                    }
                    
                    NavigationLink {
                        PaymentView()
                    } label: {
                        MyPageListItem(
                            iconName: "creditcard",
                            title: "mypage_payment".localized,
                            showChevron: false
                        )
                    }
                    
                    NavigationLink {
                        NotificationSettingsView()
                    } label: {
                        MyPageListItem(
                            iconName: "bell",
                            title: "mypage_notification".localized,
                            showChevron: false
                        )
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.white)
                
                Group {
                    NavigationLink {
                        HelpView()
                    } label: {
                        MyPageListItem(
                            iconName: "questionmark.circle",
                            title: "mypage_help".localized,
                            showChevron: false
                        )
                    }
                    
                    NavigationLink {
                        ContactView()
                    } label: {
                        MyPageListItem(
                            iconName: "headphones",
                            title: "mypage_contact".localized,
                            showChevron: false
                        )
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.white)
                
                Button(action: {
                    // ログアウト処理をここに実装
                }) {
                    MyPageListItem(
                        iconName: "rectangle.portrait.and.arrow.right",
                        title: "mypage_logout".localized,
                        textColor: .red,
                        showChevron: false
                    )
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.white)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("tab_mypage".localized)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MyPageView()
}