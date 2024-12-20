import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @StateObject private var viewModel: MainViewModel
    @State private var selectedTab = 0  // Track the selected tab
    
    init() {
        _viewModel = StateObject(wrappedValue: MainViewModel())
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text(selectedTab == 0 ? "For You" : "Future")
                .font(FontManager.customFont(.semiBold, size: 18))
                .foregroundColor(.white)
                .padding()
                .frame(height:36)
            
            TabView(selection: $selectedTab) {
                // First tab: ForYouTabView
                ForYouTabView()
                    .tabItem {
                        Label("Current", systemImage: "house.fill")

                    }
                    .tag(0)

                ZStack {
                    Color.gray.opacity(0.2)
                        .edgesIgnoringSafeArea(.all)
                    VStack {
                        Text("Future Development")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .tabItem {
                    Label("Future", systemImage: "ellipsis.circle.fill")
                }
                .tag(1)
            }
            .accentColor(.green) // This makes the selected tab icon color white
        }
        .background(Color.cardBackground) // Custom background color
        .padding(0) // Remove default padding
    }
}

#Preview {
    MainView()
}
