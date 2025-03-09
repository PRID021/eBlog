import SwiftUI

struct FullScreenImageView: View {
    var imageUrl: URL  // The image URL to load
    var height: CGFloat   // The height of the image

    var body: some View {
        AsyncImage(url: imageUrl) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(width: 300, height: height)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()  // Ensures the image maintains its aspect ratio
                    .frame(maxWidth: .infinity, maxHeight: height)  // Full width, fixed height
                    .clipped()  // Clip the image to prevent overflow
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .infinity, height: height)
            @unknown default:
                EmptyView()
            }
        }
        .edgesIgnoringSafeArea(.all)  // Ensure it spans the entire screen, including the status bar
    }
}

struct ContentView: View {
    var body: some View {
        FullScreenImageView(imageUrl: URL(string: "https://picsum.photos/200/300")!, height: 300)
            .frame(maxWidth: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
