import Alamofire
import Foundation

class NetworkLogger {

    // Helper function to colorize logs if supported
    private static func colored(_ text: String, color: String) -> String {
        // Check if the environment supports color
        if ProcessInfo.processInfo.environment["TERM_PROGRAM"] != nil {
            return "\u{001B}[\(color)m\(text)\u{001B}[0m" // ANSI escape code for color
        } else {
            return text // Plain text if no color support
        }
    }

    // Log request details for a given Request
    static func logRequest<T: Request>(_ baseURL: String, _ request: T) {
        print(colored("🚀 Request Start", color: "32")) // Green for start

        // Method and URL
        print(colored("Method: \(request.method.rawValue.uppercased())", color: "36")) // Cyan
        print(colored("URL: \(baseURL + request.path)", color: "34")) // Blue

        // Headers
        if let headers = request.headers {
            print(colored("Headers: \(headers)", color: "35")) // Magenta
        }

        // Request Body
        if let body = request.body {
            let bodyString = String(data: try! JSONSerialization.data(withJSONObject: body, options: .prettyPrinted), encoding: .utf8) ?? "Unable to parse body"
            print(colored("Body: \(bodyString)", color: "33")) // Yellow
        }

        print(colored("🚀 Request End", color: "32")) // Green for end
    }

    // Log response details
    static func logResponse<T>(response: DataResponse<T, AFError>, request: any Request) {
        if let httpResponse = response.response {
            print(colored("🎯 Response Status Code: \(httpResponse.statusCode)", color: "37")) // White
        }

        if let data = response.data {
            do {
                // Try to pretty print the response body
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    let prettyResponse = try JSONSerialization.data(withJSONObject: jsonResponse, options: .prettyPrinted)
                    let responseBody = String(data: prettyResponse, encoding: .utf8) ?? "Unable to parse response body"
                    print(colored("🎯 Response Body: \n\(responseBody)", color: "33")) // Yellow
                } else {
                    // If the response body is not a valid JSON object
                    let responseBody = String(data: data, encoding: .utf8) ?? "Unable to parse response body"
                    print(colored("🎯 Response Body: \n\(responseBody)", color: "33")) // Yellow
                }
            } catch {
                print(colored("🎯 Response Body: Error parsing JSON", color: "31")) // Red for error
            }
        }

        if let error = response.error {
            print(colored("❌ Error: \(error.localizedDescription)", color: "31")) // Red
        }
    }
}
