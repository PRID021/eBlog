import SwiftUI

struct LoginViewContent: View {
    @EnvironmentObject var appCoordinator: AppCoordinatorImpl
    @EnvironmentObject var appViewModel: AppViewModel
    
    @StateObject private var viewModel = LoginViewModel()
    @State private var isPasswordVisible = false
    
    var body: some View {
        VStack {
            Spacer()
            
            // MARK: - App Title
            Text("eBlog")
                .font(FontManager.customFont(.bold, size: 48))
                .foregroundColor(.blue)
                .padding(.bottom, 40)
            
            // MARK: - Email Field
            inputField("Email", text: $viewModel.email)
            
            // MARK: - Password Field
            passwordField
            
            // MARK: - Login Button
            Button {
                viewModel.handleLogin { _, _ in }
            } label: {
                Text("Login")
                    .font(FontManager.customFont(.medium, size: 18))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.top, 20)
            
            // MARK: - Loading Indicator
            if viewModel.isLoading {
                ProgressView("Logging in...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding(.top, 10)
            }
            
            Spacer()
            
            // MARK: - Face ID Button
            if viewModel.showFaceIdButton {
                Button {
                    viewModel.handleLoginWithFaceId { success, error in
                        if success {
                            print("Logged in successfully")
                        } else {
                            print("Error: \(error ?? "Unknown error")")
                        }
                    }
                } label: {
                    Image(systemName: "faceid")
                        .font(.largeTitle)
                }
                .padding(.bottom, 100)
            }
        }
        .padding(.horizontal)
        .background(Color.black.ignoresSafeArea())
        .onChange(of: viewModel.isLoginSuccess) { _, success in
            if success {
                appCoordinator.setRoot(.home)
                // Trigger Face ID alert globally (non-blocking)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    appViewModel.showEnableFaceIDPrompt(!viewModel.showFaceIdButton) { confirm in
                        if confirm {
                            viewModel.saveCredentialsToKeychain()
                        }
                    }
                }
            }
        }
        .onChange(of: viewModel.errorMessage) { _, message in
            if let message { appViewModel.showToastMessage(content: message) }
        }
    }
}

// MARK: - Components
private extension LoginViewContent {
    func inputField(_ placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .font(FontManager.customFont(.medium, size: 18))
            .autocapitalization(.none)
            .disableAutocorrection(true)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
    }
    
    var passwordField: some View {
        HStack {
            Group {
                if isPasswordVisible {
                    TextField("Password", text: $viewModel.password)
                } else {
                    SecureField("Password", text: $viewModel.password)
                }
            }
            .font(FontManager.customFont(.medium, size: 18))
            .autocapitalization(.none)
            .disableAutocorrection(true)
            
            Button { isPasswordVisible.toggle() } label: {
                Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .padding(.top, 10)
    }
}

//#Preview {
//    LoginViewContent()
//        .environmentObject(AppCoordinatorImpl())
//        .environmentObject(AppViewModel())
//}
