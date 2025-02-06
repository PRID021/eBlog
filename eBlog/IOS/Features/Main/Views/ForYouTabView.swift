import SwiftUI

struct ForYouTabView: View {
    
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @StateObject private var viewModel: MainViewModel
    @State private var scrollOffset: CGFloat = 0
    
    init() {
        _viewModel = StateObject(wrappedValue: MainViewModel())
    }
    
    var body: some View {
        VStack {
            Spacer()
            
            if !viewModel.posts.isEmpty {
                List {
                    ForEach(viewModel.posts.indices, id: \.self) { index in
                        VStack {
                            PostCardPreview(
                                post: viewModel.posts[index],
                                onTapReadMore: {
                                    appCoordinator.push(.postDetail(post: viewModel.posts[index]))
                                },
                                onTapLike: {
                                    print(viewModel.posts[index])
                                }
                            )
                            .background(Color.onBackground)

                            if index < viewModel.posts.count - 1 {
                                Divider()
                                    .background(Color.white.opacity(0.2))
                                    .padding(.horizontal)
                            }
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .background(Color.background)
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.background)
            }

            if viewModel.isGetFailed {
                Text("Something wrong happen.")
                    .errorTextModifier()
            }
            
            if viewModel.isLoading {
                ProgressView("Loading in...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.top, 10)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            viewModel.handleGetPosts()
        }
        .background(Color.cardBackground)
    }
}
