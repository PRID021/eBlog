import Alamofire
import Foundation

protocol AuthRepositoryProtocol {
    func authenticate(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func sendDeviceInfo(_ deviceInfo: DeviceInfo, completion: @escaping (Result<Bool, Error>) -> Void)
}

class AuthRepository: AuthRepositoryProtocol {
    static let shared = AuthRepository()
    private init() {}
    
    func authenticate(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let signInRequest = SignInRequest(email: email, password: password)
        signInRequest.performRequest(baseURL: AuthAPIEndpoint.baseURL) { result in
            switch result {
            case .success(let authResponse):
                LocalDataManager.shared.storeToken(accessToken: authResponse.accessToken,
                                                 refreshToken: authResponse.refreshToken)
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func sendDeviceInfo(_ deviceInfo: DeviceInfo, completion: @escaping (Result<Bool, Error>) -> Void) {
        let tokens = LocalDataManager.shared.retrieveTokens()
        
        guard let accessToken = tokens.accessToken else {
            let error = NSError(domain: "", code: -1,
                              userInfo: [NSLocalizedDescriptionKey: "No access token available"])
            completion(.failure(error))
            return
        }
        
        let deviceInfoRequest = DeviceInfoRequest(deviceInfo: deviceInfo, accessToken: accessToken)
        deviceInfoRequest.performRequest(baseURL: AuthAPIEndpoint.baseURL) { result in
            switch result {
            case .success:
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
