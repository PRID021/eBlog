import Foundation

// Define scheme and default domain as constants
let scheme = "http"
// Use environment IP if available, otherwise fall back to default
let defaultDomain = "localhost:3000"
var domainUrl: String = {
    if let ip = Bundle.main.object(forInfoDictionaryKey: "IP") as? String {
        print("IP from Info.plist: \(ip)")
        return "\(ip):3000"
    }
    print("Using default domain: \(defaultDomain)")
    return defaultDomain
}()

// API Endpoint protocol
public protocol APIEndpoint {
    static var baseURL: String { get }
    var path: String { get }
}

// Auth endpoint implementation
struct AuthAPIEndpoint: APIEndpoint {
    static var baseURL: String {
        return "\(scheme)://\(domainUrl)"
    }
    var path: String = "auth"
}

// Featuring endpoint implementation
struct FeaturingApiEndpoint: APIEndpoint {
    static var baseURL: String {
        return "\(scheme)://\(domainUrl)"
    }
    var path: String = ""
}
