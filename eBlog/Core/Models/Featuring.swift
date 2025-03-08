//
//  Untitled.swift
//  eBlog
//
//  Created by mac on 8/3/25.
//

import Foundation

// Define the response model conforming to Decodable
struct Featuring: Decodable, Encodable, Hashable {
    let id: Int
    let desktopMedia: URL
    let mobileMedia: URL
    let imageAlt: String
    let heading: String
    let text: String
    
    // Map snake_case to camelCase using CodingKeys
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case desktopMedia = "desktop_media"
        case mobileMedia = "mobile_media"
        case imageAlt = "imageAlt"
        case heading = "heading"
        case text = "text"
    }
}
