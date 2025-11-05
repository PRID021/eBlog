import Foundation
import Alamofire

// AuthEndpoint conforming to Request protocol

struct EmptyResponse: Codable {
    // Empty struct that satisfies Codable
}

struct SignInRequest: Request {
    typealias ReturnType = AuthResponse

    var path: String = "auth/authenticate"  // The path for sign-in endpoint
    var method: Alamofire.HTTPMethod = .post
    var body: [String: Any]?
    var headers: [String: String]?

    // Initialize with email and password
    init(email: String, password: String) {
        self.body = [
            "user_name": email,
            "password": password
        ]
        self.headers = [
            "Content-Type": "application/json"
        ]
    }
}

struct DeviceInfoRequest: Request {
    typealias ReturnType = EmptyResponse
    var path: String = "auth/device_info"
    var method: Alamofire.HTTPMethod = .post
    var body: [String: Any]?
    var headers: [String: String]?
    
    init(deviceInfo: DeviceInfo, accessToken: String) {
        self.body = try? JSONEncoder().encode(deviceInfo).toDictionary()
        self.headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(accessToken)"
        ]
    }
}

// Helper extension for converting Data to Dictionary
extension Data {
    func toDictionary() -> [String: Any]? {
        try? JSONSerialization.jsonObject(with: self, options: []) as? [String: Any]
    }
}
