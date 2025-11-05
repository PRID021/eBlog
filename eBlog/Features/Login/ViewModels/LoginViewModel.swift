import SwiftUI
import Combine
import LocalAuthentication
import SwiftKeychainWrapper

final class LoginViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoading: Bool = false
    @Published var isLoginSuccess: Bool = false
    @Published var isLoginFailed: Bool = false
    @Published var errorMessage: String?
    @Published var showFaceIdButton: Bool = false
  

    // MARK: - Dependencies
    private let loginService: AuthRepositoryProtocol

    // MARK: - Init
    init(loginService: AuthRepositoryProtocol = AuthRepository.shared) {
        self.loginService = loginService
        self.showFaceIdButton = biometricLoginEnabled()
    }

    // MARK: - Login Flow
    func handleLogin(completion: @escaping (Bool, String?) -> Void) {
        guard !email.isEmpty, !password.isEmpty else {
            updateLoginState(failed: true, message: "Email and password cannot be empty")
            completion(false, "Email and password cannot be empty")
            return
        }

        isLoading = true
        errorMessage = nil

        loginService.authenticate(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success:
                    self.handleLoginSuccessFlow()
                    completion(true, nil)
                case .failure(let error):
                    self.updateLoginState(failed: true, message: error.localizedDescription)
                    completion(false, error.localizedDescription)
                }
            }
        }
    }

    private func handleLoginSuccessFlow() {
        isLoginSuccess = true
        isLoginFailed = false
        registerDeviceIfNeeded()

        if biometricLoginEnabled() {
            saveCredentialsToKeychain()
        }
    }

    private func updateLoginState(failed: Bool, message: String?) {
        isLoginFailed = failed
        errorMessage = message
        isLoading = false
    }

    // MARK: - Device Registration
    private func registerDeviceIfNeeded() {
        guard let tokenString = UserDefaults.standard.string(forKey: "apnsToken") else {
            print("⚠️ No APNs token found")
            return
        }

        let deviceInfo = DeviceInfo(deviceToken: Data(tokenString.utf8))
        loginService.sendDeviceInfo(deviceInfo) { result in
            switch result {
            case .success(let response):
                print("✅ Device registered successfully: \(response)")
            case .failure(let error):
                print("❌ Failed to register device: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Face ID / Keychain Handling
    func handleLoginWithFaceId(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        context.localizedCancelTitle = "Enter Username/Password"
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            completion(false, "Face ID not available on this device")
            return
        }

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Scan your face to login") { [weak self] success, authError in
            DispatchQueue.main.async {
                guard let self = self else { return }

                if success {
                    self.loginWithSavedCredentials { result, error in
                        if !result {
                            print("❌ Face ID login failed: \(error ?? "Unknown error")")
                            self.clearSavedCredentials()
                        } else {
                            print("✅ Face ID login succeeded")
                        }
                        completion(result, error)
                    }
                } else {
                    self.clearSavedCredentials()
                    completion(false, authError?.localizedDescription)
                }
            }
        }
    }

    func saveCredentialsToKeychain() {
        KeychainWrapper.standard.set(email, forKey: "savedEmail")
        KeychainWrapper.standard.set(password, forKey: "savedPassword")
        showFaceIdButton = true
        print("🔐 Credentials saved to Keychain for email: \(email) password: \(password)")
    }

    private func clearSavedCredentials() {
        KeychainWrapper.standard.removeObject(forKey: "savedEmail")
        KeychainWrapper.standard.removeObject(forKey: "savedPassword")
        email = ""
        password = ""
        showFaceIdButton = false
        print("🔒 Credentials cleared from Keychain")
    }

    private func loginWithSavedCredentials(completion: @escaping (Bool, String?) -> Void) {
        guard let savedEmail = KeychainWrapper.standard.string(forKey: "savedEmail"),
              let savedPassword = KeychainWrapper.standard.string(forKey: "savedPassword") else {
            completion(false, "No saved credentials found")
            return
        }

        email = savedEmail
        password = savedPassword
        handleLogin(completion: completion)
    }

    private func biometricLoginEnabled() -> Bool {
        KeychainWrapper.standard.string(forKey: "savedEmail") != nil &&
        KeychainWrapper.standard.string(forKey: "savedPassword") != nil
    }
}
