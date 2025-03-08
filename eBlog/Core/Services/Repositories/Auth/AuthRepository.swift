import Alamofire
import Foundation

class AuthRepository {

    // Function to authenticate user with username and password
    func authenticate(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        // Create the AuthEndpoint instance
        let signInRequest = SignInRequest(email: email, password: password)
        
        // Perform the request using Alamofire's Request extension
        signInRequest.performRequest(baseURL: AuthAPIEndpoint.baseURL) { result in
            switch result {
            case .success(let authResponse):
                LocalDataManager.shared.storeToken(accessToken: authResponse.accessToken, refreshToken: authResponse.refreshToken)
                completion(.success(true))  // Login successful
            case .failure(let error):
                completion(.failure(error))  // Error in login
            }
        }
    }
}
