import SwiftUI

struct PostCardPreview: View {
    var post: Post  // Assuming `Post` is the type that holds the data like imgUrl, title, etc.
    var onTapReadMore: () -> Void // Tap callback closure
    var onTapLike: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Title
            Text(post.title)
                .font(FontManager.customFont(.bold, size: 16))
                .lineLimit(2)
                .primaryTextModifier()
                .padding(.horizontal)
                .padding(.top)

            // Short Description
            Text(post.shortDescription)
                .font(FontManager.customFont(.semiBold, size: 14))
                .lineLimit(3)
                .secondaryTextModifier()
                .padding(.horizontal)

            // Image
            AsyncImage(url: URL(string: post.imgUrl)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity, maxHeight: 200)

                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .clipped() // Ensure no overflow

                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .foregroundColor(.gray)

                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 200)

            // Like and Read HStack
            HStack(spacing: 20) {
                HStack {
                    Image(systemName: "hand.thumbsup")
                        .foregroundColor(.blue)
                    Text("Like")
                        .font(FontManager.customFont(.regular, size: 14))
                        .foregroundColor(.white)
               
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    onTapLike() // Execute the tap callback
                }

                HStack {
                    Image(systemName: "book")
                        .foregroundColor(.green)
                    Text("Read more")
                        .font(FontManager.customFont(.regular, size: 14))
                        .foregroundColor(.white)
               
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    onTapReadMore() // Execute the tap callback
                }

                Spacer() // Push icons to the left
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color.onBackground)

        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2) // Shadow for depth

    }
}

#Preview {
    PostCardPreview(
        post: Post(
            id: 3,
            authorId: 1,
            title: "Natural Language Processing",
            content: """
                # Markdown Content Example
                This is an example of **Markdown** content.
                
                - Item 1
                - Item 2
                - Item 3

                ## Subheading
                Here's some more detailed text.
                """,
            shortDescription: "An introduction to NLP.",
            imgUrl: "https://i.pravatar.cc/300"
        ),
        onTapReadMore: { print("Card tapped!") },
        onTapLike: {print("Card tapped!")}
    )
}
