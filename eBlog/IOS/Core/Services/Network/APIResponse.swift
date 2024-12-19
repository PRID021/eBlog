//
//  APIResponse.swift
//  eBlog
//
//  Created by mac on 19/12/24.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let data: T
    let statusCode: Int
    let message: String
}
