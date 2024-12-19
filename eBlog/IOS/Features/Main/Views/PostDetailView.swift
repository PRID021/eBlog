import SwiftUI
import MarkdownUI  // Import the MarkdownUI package

struct PostDetailView: View {
    var post: Post  // Assuming Post model holds title, content, etc.

    var body: some View {
        
        ZStack {
            Color.cardBackground
                .edgesIgnoringSafeArea(.all) // Ensures the background spans the entire screen, including status bar
            ScrollView {
                Markdown {
                    post.content
                }
                .markdownTextStyle(\.text) {
                    FontFamilyVariant(.monospaced)
                    ForegroundColor(Color.white)
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(post.title)
                        .foregroundColor(.white) // Set the title text color to white
                        .font(FontManager.customFont(.bold, size: 16))
                        .lineLimit(1)
                }
            }
           
        }

        
    }
}
