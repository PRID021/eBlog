import SwiftUI
import Combine
import LocalAuthentication
import SwiftKeychainWrapper

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoginFailed: Bool = false
    @Published var isLoading: Bool = false
    @Published var isLoginSuccess: Bool = false
    @Published var errorMessage: String? = nil
    @Published var showFaceIdButton: Bool = false

    private var loginService: AuthRepository

    init(loginService: AuthRepository = AuthRepository()) {
        self.loginService = loginService
        self.showFaceIdButton = biometricLoginEnabled()
    }

    // Handle login action
    func handleLogin(completion: @escaping (Bool, String?) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            DispatchQueue.main.async {
                self.isLoginFailed = true
                self.errorMessage = "Email and password cannot be empty"
            }
            completion(false, "Email and password cannot be empty")
            return
        }
        
        isLoading = true
        isLoginFailed = false
        errorMessage = nil
        
        loginService.authenticate(email: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                switch result {
                case .success(_):
                    self.isLoginFailed = false
                    self.isLoginSuccess = true
                    
                    if !self.biometricLoginEnabled() {
                        self.promptEnableFaceID()
                    }else {
                        self.saveCredentialsToKeychain()
                    }
                    completion(true, nil)
                    

                case .failure(let error):
                    self.isLoginFailed = true
                    self.errorMessage = error.localizedDescription
                    completion(false, error.localizedDescription)
                }
            }
        }
    }

    // Ask the user if they want to enable Face ID after login
    func promptEnableFaceID() {
        let alert = UIAlertController(
            title: "Enable Face ID",
            message: "Would you like to enable Face ID for faster login?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.saveCredentialsToKeychain()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        DispatchQueue.main.async {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                rootVC.present(alert, animated: true)
            }
        }
    }

    // Save credentials securely to Keychain
    func saveCredentialsToKeychain() {
        KeychainWrapper.standard.set(email, forKey: "savedEmail")
        KeychainWrapper.standard.set(password, forKey: "savedPassword")
        
        DispatchQueue.main.async {
            self.showFaceIdButton = true
        }
    }

    // Login using Face ID
    func handleLoginWithFaceId(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        context.localizedCancelTitle = "Enter Username/Password"
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Scan your face to login"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.loginWithSavedCredentials(completion: completion)
                    } else {
                        completion(false, authenticationError?.localizedDescription)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(false, "Face ID not available on this device")
            }
        }
    }

    // Retrieve credentials from Keychain and login
    func loginWithSavedCredentials(completion: @escaping (Bool, String?) -> Void) {
        guard let savedEmail = KeychainWrapper.standard.string(forKey: "savedEmail"),
              let savedPassword = KeychainWrapper.standard.string(forKey: "savedPassword") else {
            DispatchQueue.main.async {
                completion(false, "No saved credentials found")
            }
            return
        }
        
        DispatchQueue.main.async {
            self.email = savedEmail
            self.password = savedPassword
            self.handleLogin(completion: completion)
        }
    }

    // Check if biometric login is enabled (credentials exist in Keychain)
    func biometricLoginEnabled() -> Bool {
        return KeychainWrapper.standard.string(forKey: "savedEmail") != nil &&
               KeychainWrapper.standard.string(forKey: "savedPassword") != nil
    }
}
