import SwiftUI
import MarkdownUI  // Import the MarkdownUI package



struct PostDetailView: View {
    var post: Post  // Assuming Post model holds title, content, etc.
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    // Example comments with user info
    @State private var comments: [Comment] = [
        Comment(message: "Great post!", commentUser: "John Doe", userAvatar: "https://i.pravatar.cc/300"),
        Comment(message: "Thanks for sharing!, This's a greatest post i ever seen. I hope you will continues release new article support community like this.", commentUser: "Jane Smith", userAvatar: "https://i.pravatar.cc/300"),
        Comment(message: "Very informative.", commentUser: "Alice Johnson", userAvatar: "https://i.pravatar.cc/300")
    ]
    @State private var currentUserMessage: String = ""
    
    @State private var isAtBottom: Bool = false
    @State private var isUserScrolling: Bool = false
    @ObservedObject private var keyboardObserver = KeyboardObserver()

    var btnBack: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "arrow.left")
                    .font(FontManager.customFont(.bold, size: 16))
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
            }
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.cardBackground
                .edgesIgnoringSafeArea(.all) // Ensures the background spans the entire screen, including status bar
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    FullScreenImageView(imageUrl: post.imgUrl, height: 300)
                        .frame(maxWidth: .infinity)
                    
                    // Markdown Content
                    Markdown {
                        post.content
                    }
                    .markdownTextStyle(\.text) {
                        FontFamilyVariant(.monospaced)
                        ForegroundColor(Color.white)
                    }
                    .padding()
                    
                    Divider()
                        .frame(height: 1)
                        .background(Color.white.opacity(0.2)) // Styled to match the UI theme

                    // Comments Section
                    
                    VStack(alignment: .leading, spacing: 15) {
                         Text("Comments")
                             .font(FontManager.customFont(.bold, size: 18))
                             .foregroundColor(.white)

                         ForEach(comments, id: \.message) { comment in
                             HStack (alignment: .top){
                                 AsyncImage(url: URL(string: comment.userAvatar)) { phase in
                                     switch phase {
                                     case .empty:
                                         ProgressView()
                                             .frame(width: 40, height: 40)
                                             .clipShape(Circle())
                                     case .success(let image):
                                         image
                                             .resizable()
                                             .scaledToFill()
                                             .clipShape(Circle())
                                             .frame(width: 40, height: 40)
                                     case .failure:
                                         Image(systemName: "person.circle.fill")
                                             .resizable()
                                             .scaledToFill()
                                             .frame(width: 40, height: 40)
                                             .clipShape(Circle())
                                     @unknown default:
                                         EmptyView()
                                     }
                                 }
                                 .padding(.vertical,8)

                                 VStack(alignment: .leading, spacing: 5) {
                                     Text(comment.commentUser)
                                         .font(FontManager.customFont(.bold, size: 14))
                                         .foregroundColor(.white)

                                     Text(comment.message)
                                         .font(FontManager.customFont(.regular, size: 14))
                                         .foregroundColor(.white)
                                         .padding(5)
                                         .background(Color.gray.opacity(0.2))
                                         .cornerRadius(8)
                                 }
                                 .padding(.leading, 10)
                             }
                         }

                        // Detect scroll position
                        GeometryReader { geometry in
                            Color.clear
                                .onChange(of: geometry.frame(in: .global).maxY) { value in
                                    let scrollViewHeight = UIScreen.main.bounds.height
                                    let contentHeight = value
                                    
                                    // Update isAtBottom based on scroll position
                                    if !isUserScrolling {
                                        if contentHeight <= scrollViewHeight {
                                            self.isAtBottom = true
                                        } else {
                                            self.isAtBottom = false
                                        }
                                    }
                                }
                        }
                        .frame(height: 0) // Make GeometryReader invisible
                    }
                    .padding()
                    
                }
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 20) // Adds padding at the top
                }
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 80 )
                }
            }

            
            // Bottom comment input view
            if isAtBottom {
                HStack {
                    TextField("",text: $currentUserMessage,axis:.vertical)
                        .font(FontManager.customFont(.regular, size: 14))
                        .placeholder(when: currentUserMessage.isEmpty) {
                            Text("Typing your comment ....").foregroundColor(.gray)
                        }
                        .lineLimit(1...5)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)

                    Button(action: addComment) {
                        // Send icon
                        Image(systemName: "paperplane.fill") // The "send" icon
                            .font(.title2) // Adjust the icon size
                            .foregroundColor(.white)
                            .padding(.leading, 5) // Spacing between text and icon
                    }
                    
                }
                .padding()
                .background(Color.onBackground)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(post.title)
                    .foregroundColor(.white) // Set the title text color to white
                    .font(FontManager.customFont(.bold, size: 16))
                    .lineLimit(1)
            }
        }
        .toolbarBackground(Color.background, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: btnBack)
    }

    // Add comment function
    private func addComment() {
        guard !currentUserMessage.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        // Add new comment and scroll to the bottom
        comments.insert(Comment(message: currentUserMessage, commentUser: "hoang.pham", userAvatar: "https://i.pravatar.cc/300"), at: 0)
        currentUserMessage = ""
        
        // Scroll to bottom and set isAtBottom to true
        DispatchQueue.main.async {
            self.isAtBottom = true
        }
    }
}

#Preview {
    PostDetailView(
        post: Post(
            id: 1,
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
            imgUrl: "https://example.com/image.jpg"
        )
    )
}
