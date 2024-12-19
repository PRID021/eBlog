import SwiftUI
import MarkdownUI

struct MainView: View {
    
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @StateObject private var viewModel: MainViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: MainViewModel())
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            if !viewModel.posts.isEmpty {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.posts, id: \.id) { post in
                            HStack {
                                // Image
                                AsyncImage(url: URL(string: post.imgUrl)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 100)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100)
                                    case .failure:
                                        Image(systemName: "photo")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width:100)
                                            .foregroundColor(.gray)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                                
                                // Text content
                                VStack(alignment: .leading, spacing: 10) {
                                    Text(post.title)
                                        .font(FontManager.customFont(.bold, size: 16))
                                        .lineLimit(2) // Truncate if the title is too long
                                    Text(post.shortDescription)
                                        .font(FontManager.customFont(.semiBold, size: 14))
                                        .lineLimit(2) // Allow 2 lines for description, truncate if needed
                                }
                                .padding(.trailing, 16)
                                .frame(maxWidth: .infinity) // Take up remaining space in HStack
                            }
                            .frame(height: 120) // Set a consistent height for the cards
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                        }
                    }
                    .padding()
                }
            }
            
            if viewModel.isGetFailed {
                Text("Invalid username or password.")
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, 10)
            }
            
            if viewModel.isLoading {
                ProgressView("Loading in...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.top, 10)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Make the VStack take full screen size
        .background(Color.black)
        .onAppear {
            viewModel.handleGetPosts()
        }
    }
}

#Preview {
    MainView()
}
