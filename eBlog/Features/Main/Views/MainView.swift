// MainView.swift
import SwiftUI

struct MainView: View {
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @StateObject private var viewModel: MainViewModel
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        _viewModel = StateObject(wrappedValue: MainViewModel())
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.selectedTab == 0 ? "For You" : "Future")
                .font(FontManager.customFont(.semiBold, size: 18)) // Assuming FontManager exists
                .foregroundColor(.white)
                .padding()
                .frame(height: 36)
            
            TabView(selection: $viewModel.selectedTab) {
                ForYouTabView()
                    .tabItem {
                        Label("Current", systemImage: "house.fill")
                    }
                    .tag(0)
                
                APNView()
                    .tabItem {
                        Label("Future", systemImage: "ellipsis.circle.fill")
                    }
                    .tag(1)
            }
            .accentColor(.green)
        }
        .background(Color.cardBackground) // Assuming Color.cardBackground exists
        .padding(0)
        .environmentObject(viewModel)
        .alert(isPresented: $viewModel.showSettingsAlert) {
            Alert(
                title: Text("Notifications Disabled"),
                message: Text("Please go to Settings to enable notifications."),
                primaryButton: .default(Text("Settings")) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                },
                secondaryButton: .cancel()
            )
        }
        .onChange(of: viewModel.selectedTab) {
                    if viewModel.selectedTab == 1 {
                        viewModel.requestPermissionIfNeeded()
                    }
                }
        .onChange(of: scenePhase) {
            if scenePhase == .active && viewModel.selectedTab == 1 {
                viewModel.requestPermissionIfNeeded()
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AppCoordinatorImpl())
}
