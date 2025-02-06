import SwiftUI

import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = "hoangduc.uit.dev@gmail.com"
    @Published var password: String = "Password123@@"
    @Published var isLoginFailed: Bool = false
    @Published var isLoading: Bool = false
    @Published var isLoginSuccess: Bool = false
    @Published var errorMessage: String? = nil

    private var loginService: AuthRepository

    init(loginService: AuthRepository = AuthRepository()){
        self.loginService = loginService;
    }

    // Handle login action
    func handleLogin() {
        guard !email.isEmpty, !password.isEmpty else {
            isLoginFailed = true
            return
        }
        
        isLoading = true
        isLoginFailed = false
        errorMessage = nil
        
        loginService.authenticate(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success( _):
                    self?.isLoginFailed = false
                    self?.isLoginSuccess = true
                    // Handle successful login, e.g., navigate to a new screen
                    
                case .failure(let error):
                    // Handle failure, e.g., show an error message
                    self?.isLoginFailed = true
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
