import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @StateObject private var viewModel: MainViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: MainViewModel())
    }
    
    var body: some View {
        ZStack {
            // Apply the background color to the entire screen
            Color.background
                .edgesIgnoringSafeArea(.all) // Ensures the background spans the entire screen, including status bar
            
            VStack {
                Spacer()
                
                if !viewModel.posts.isEmpty {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.posts, id: \.id) { post in
                                PostCardPreview(post: post) {
                                    appCoordinator.push(.postDetail(post: post))
                                }
                            }
                        }
                    }
                }
                
                // Error message
                if viewModel.isGetFailed {
                    Text("Invalid username or password.")
                        .errorTextModifier()  // Apply the custom error text modifier
                }
                
                // Loading state
                if viewModel.isLoading {
                    ProgressView("Loading in...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding(.top, 10)
                }

                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Make the VStack take full screen size
            .onAppear {
                viewModel.handleGetPosts()
            }
        }
    }
}

#Preview {
    MainView()
}
