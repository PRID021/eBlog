import SwiftUI

struct LoginViewContent: View {
  
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @EnvironmentObject var appViewModel: AppViewModel
    
    @StateObject private var viewModel: LoginViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: LoginViewModel())
    }

    var body: some View {
        VStack {
            Spacer()
            
            // App Title or Logo
            Text("eBlog")
                .font(FontManager.customFont(.bold, size: 48))
                .foregroundColor(.blue)
                .padding(.bottom, 40)
            
            // Username Field
            TextField("Email", text: $viewModel.email)
                .font(FontManager.customFont(.medium, size: 18))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            // Password Field
            SecureField("Password", text: $viewModel.password)
                .font(FontManager.customFont(.medium, size: 18))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .padding(.horizontal)
                .padding(.top, 10)
            
            // Login Button
            Button(action: {
                viewModel.handleLogin()
            }) {
                Text("Login")
                    .font(FontManager.customFont(.medium, size: 18))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.top, 20)

            
            // Loading Indicator
            if viewModel.isLoading {
                ProgressView("Logging in...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.top, 10)
            }

            Spacer()
        }
        .onChange(of: viewModel.isLoginSuccess) { _, isSuccess in
            if isSuccess {
                appCoordinator.setRoot(.home)  // Navigate to the home screen
            }
        }
        .onChange(of: viewModel.errorMessage) { _, newError in
            if let newError = newError {
                appViewModel.showToastMessage(content: newError)
            }
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    LoginViewContent()
}
