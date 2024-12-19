import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    @Published var email: String = "hoangduc.uit.dev@gmail.com"
    @Published var password: String = "Password123@@"
    @Published var isLoginFailed: Bool = false
    @Published var isLoading: Bool = false

    
    private var loginService: AuthRepository
    
    private var coordinator: any AppCoordinatorProtocol
    
    init( coordinator: any AppCoordinatorProtocol,loginService: AuthRepository = AuthRepository()) {
        self.loginService = loginService
        self.coordinator = coordinator
    }

    // Handle login action
    func handleLogin() {
        guard !email.isEmpty, !password.isEmpty else {
            isLoginFailed = true
            return
        }
        
        isLoading = true
        isLoginFailed = false
        loginService.authenticate(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success( _):
                    self?.isLoginFailed = false
                    self?.coordinator.setRoot(Screen.home)
                    // Handle successful login, e.g., navigate to a new screen
                    
                case .failure(let error):
                    // Handle failure, e.g., show an error message
                    self?.isLoginFailed = true
                    print("Login failed with error: \(error.localizedDescription)")
                }
            }
        }
    }
}
