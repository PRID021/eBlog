import Foundation
import Alamofire

// AuthEndpoint conforming to Request protocol

struct SignInRequest: Request {
    typealias ReturnType = AuthResponse

    var path: String = "auth/sign-in"  // The path for sign-in endpoint
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
