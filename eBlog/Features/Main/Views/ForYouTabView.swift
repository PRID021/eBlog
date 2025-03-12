// ForYouTabView.swift
import SwiftUI

struct ForYouTabView: View {
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @EnvironmentObject var viewModel: MainViewModel
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        VStack {
            Spacer()
            
            if !viewModel.featurings.isEmpty {
                List(viewModel.featurings, id: \.id) { featuring in
                    VStack {
                        FeaturingCardPreview(
                            featuring: featuring,
                            onTapReadMore: {
                                appCoordinator.push(.featuringDetail(featuring: featuring))
                            },
                            onTapLike: {
                                print(featuring)
                            }
                        )
                        .background(Color.onBackground)
                        
                        Divider()
                            .background(Color.white.opacity(0.2))
                            .padding(.horizontal)
                    }
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                    .background(Color.background)
                }
                .listStyle(PlainListStyle())
                .background(Color.background)
            }
            
            if viewModel.isGetFailed {
                Text("Something went wrong.")
                    .errorTextModifier()
            }
            
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.top, 10)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            viewModel.handleGetFeaturings()
        }
        .background(Color.cardBackground)
    }
}

#Preview {
    ForYouTabView()
        .environmentObject(AppCoordinatorImpl())
        .environmentObject(MainViewModel())
}
