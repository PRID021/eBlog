import Foundation
import KeychainSwift

class LocalDataManager {
    private let keychain = KeychainSwift()
    
    // Step 1: Create a shared static instance for singleton
    static let shared = LocalDataManager()
    
    // Step 2: Make the initializer private to prevent instantiation
    private init() {}
    
    // Store access and refresh tokens in Keychain
    func storeToken(accessToken: String, refreshToken: String) {
        keychain.set(accessToken, forKey: "accessToken", withAccess: .accessibleWhenUnlocked)
        keychain.set(refreshToken, forKey: "refreshToken", withAccess: .accessibleWhenUnlocked)
    }
    
    // Retrieve tokens from Keychain
    func retrieveTokens() -> (accessToken: String?, refreshToken: String?) {
        let accessToken = keychain.get("accessToken")
        let refreshToken = keychain.get("refreshToken")
        return (accessToken, refreshToken)
    }
    
    // Delete tokens from Keychain
    func deleteTokens() {
        keychain.delete("accessToken")
        keychain.delete("refreshToken")
    }
}
