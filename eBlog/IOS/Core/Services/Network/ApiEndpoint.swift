//
//  ApiEndpoint.swift
//  eBlog
//
//  Created by mac on 19/12/24.
//

import Foundation

var scheme: String = "http"
var domainUrl: String = "192.168.100.43:3000"

public protocol APIEndpoint {
    static  var baseURL: String { get }
    var path: String { get }
}


struct AuthAPIEndpoint : APIEndpoint {
    static var baseURL: String {
        return "\(scheme)://\(domainUrl)"
    }
    var path: String = "auth"
}


