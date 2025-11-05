//
//  Request.swift
//  eBlog
//
//  Created by mac on 19/12/24.
//

import Foundation
import Alamofire



public protocol Request {
    var path: String { get }
    var method: Alamofire.HTTPMethod { get }
    var contentType: String { get }
    var body: [String: Any]? { get }
    var headers: [String: String]? { get }
    var queryParams: [String: String]? { get }
    associatedtype ReturnType: Codable
}

extension Request {
    var method: Alamofire.HTTPMethod { return .get }
    var contentType: String { return "application/json" }
    var queryParams: [String: String]? { return nil }
    var body: [String: Any]? { return nil }
    var headers: [String: String]? { return nil }
    
}

extension Request {
    
    // Convert parameters to JSON data
    private func requestBodyFrom(params: [String: Any]?) -> Data? {
        guard let params = params else { return nil }
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return nil
        }
        return httpBody
    }

    // Updated performRequest to use APIResponse wrapper
    func performRequest(baseURL: String, completion: @escaping (Result<ReturnType, AFError>) -> Void) {
        // Construct the full URL
        guard var urlComponents = URLComponents(string: baseURL) else { return }
        urlComponents.path = "\(urlComponents.path)/\(path)"
        
        guard let finalURL = urlComponents.url else { return }
        
        // Request headers and body (if any)
        var requestHeaders = headers ?? [:]
        requestHeaders["Content-Type"] = contentType
        var didComplete = false
        NetworkLogger.logRequest(baseURL, self)
        
        AF.request(finalURL,
                   method: method,
                   parameters: body,
                   encoding: JSONEncoding.default,
                   headers: HTTPHeaders(requestHeaders))
            .validate() // Validate the response
            .responseData { response in
                if let statusCode = response.response?.statusCode,
                   (statusCode == 204 || (statusCode == 200 && (response.data == nil || response.data?.isEmpty == true))) {
                    
                    NetworkLogger.logResponse(response: response, request: self)
                    
                    if let empty = EmptyResponse() as? ReturnType {
                        didComplete = true
                        completion(.success(empty))
                    } else {
                        didComplete = true
                        completion(.failure(AFError.responseSerializationFailed(reason: .inputDataNilOrZeroLength)))
                    }
                }
            }
            .responseDecodable(of: APIResponse<ReturnType>.self) { response in
                guard !didComplete else { return }
                NetworkLogger.logResponse(response: response, request: self)
                switch response.result {
                case .success(let decodedResponse):
                    // Pass the decoded `data` to the completion handler
                    completion(.success(decodedResponse.data))
                case .failure(let error):
                    var errorMessage = error.localizedDescription

                     if let data = response.data {
                         do {
                             if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
                                let message = jsonResponse["message"] as? String,
                                let statusCode = jsonResponse["statusCode"] as? Int {
                                 errorMessage = "[\(statusCode)] \(message)" // Custom error message
                             }
                         } catch {
                             print("Failed to parse error response: \(error.localizedDescription)")
                         }
                     }
                     // Pass a custom error with the new message
                     let customError = NSError(domain: "APIError", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
                     completion(.failure(AFError.createURLRequestFailed(error: customError)))
                }
            }
    }
}
