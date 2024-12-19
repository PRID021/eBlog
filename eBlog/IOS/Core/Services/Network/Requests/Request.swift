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
        
        NetworkLogger.logRequest(baseURL, self)
        
        AF.request(finalURL,
                   method: method,
                   parameters: body,
                   encoding: JSONEncoding.default,
                   headers: HTTPHeaders(requestHeaders))
            .validate() // Validate the response
            .responseDecodable(of: APIResponse<ReturnType>.self) { response in
                NetworkLogger.logResponse(response: response, request: self)
                
                switch response.result {
                case .success(let decodedResponse):
                    // Pass the decoded `data` to the completion handler
                    completion(.success(decodedResponse.data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
