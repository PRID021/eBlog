import Foundation

// Define the response model conforming to Decodable
struct AuthResponse: Decodable, Encodable {
    let accessToken: String
    let refreshToken: String
    
    // Map snake_case to camelCase using CodingKeys
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
