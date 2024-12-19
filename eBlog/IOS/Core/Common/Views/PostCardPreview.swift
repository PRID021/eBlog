import SwiftUI

struct PostCardPreview: View {
    var post: Post  // Assuming `Post` is the type that holds the data like imgUrl, title, etc.
    var onTap: () -> Void // Tap callback closure

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: post.imgUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white)) 
                        .frame(width: 100, height: 100)

                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100)
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(post.title)
                    .font(FontManager.customFont(.bold, size: 16))
                    .lineLimit(2)
                    .primaryTextModifier() // Apply primary text modifier
                Text(post.shortDescription)
                    .font(FontManager.customFont(.semiBold, size: 14))
                    .lineLimit(3)
                    .secondaryTextModifier() // Apply secondary text modifier
            }
            .padding(.trailing, 16)
            .frame(maxWidth: .infinity) // Take up remaining space in HStack
        }
        .frame(height: 120) // Set a consistent height for the cards
        .cardBackgroundModifier() // Apply background modifier to the card
        .shadowModifier() // Apply shadow to the card
        .onTapGesture {
            onTap() // Trigger the callback when the card is tapped
        }
    }
}
