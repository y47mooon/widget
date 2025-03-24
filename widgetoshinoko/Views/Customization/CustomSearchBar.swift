//
//  CustomSearchBar.swift
//  widgetoshinoko
//
//  Created by ゆぅ on 2025/03/14.
//

import Foundation
import SwiftUI

struct CustomSearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("search_placeholder".localized, text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .cornerRadius(10)
        .padding(.horizontal, 16)
    }
}
