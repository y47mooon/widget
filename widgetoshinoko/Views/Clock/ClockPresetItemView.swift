import SwiftUI

struct ClockPresetItemView: View {
    let preset: ClockPreset
    
    var body: some View {
        VStack {
            Image(systemName: preset.thumbnailImageName)
                .font(.system(size: 40))
                .foregroundColor(.blue)
                .frame(height: 60)
            
            Text(preset.title)
                .font(.headline)
                .lineLimit(1)
            
            Text(preset.description)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
