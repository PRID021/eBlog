import SwiftUI

struct FeaturingCardPreview: View {
    var featuring: Featuring
    var onTapReadMore: () -> Void // Tap callback closure
    var onTapLike: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Title
            Text(featuring.heading)
                .font(FontManager.customFont(.bold, size: 16))
                .lineLimit(2)
                .primaryTextModifier()
                .padding(.horizontal)
                .padding(.top)

            // Short Description
            Text(featuring.text)
                .font(FontManager.customFont(.semiBold, size: 14))
                .lineLimit(3)
                .secondaryTextModifier()
                .padding(.horizontal)

            // Image
            AsyncImage(url: featuring.mobileMedia) { phase in
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
