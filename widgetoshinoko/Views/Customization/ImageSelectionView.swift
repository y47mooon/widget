import SwiftUI
import PhotosUI

struct ImageSelectionView: View {
    @State private var selectedImage: UIImage?
    @State private var photoItem: PhotosPickerItem?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("画像")
                .font(.headline)
            
            PhotosPicker(selection: $photoItem,
                        matching: .images) {
                if let selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 200)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "photo")
                                    .font(.system(size: 24))
                                Text("タップして画像を選択")
                                    .font(.subheadline)
                            }
                            .foregroundColor(.gray)
                        )
                }
            }
        }
        .onChange(of: photoItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                }
            }
        }
    }
}

#Preview {
    ImageSelectionView()
        .padding()
}

