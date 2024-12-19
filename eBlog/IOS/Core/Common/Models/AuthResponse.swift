import Foundation

// Define the response model conforming to Decodable
struct AuthResponse: Decodable, Encodable {
    let accessToken: String
    let refreshToken: String
}
