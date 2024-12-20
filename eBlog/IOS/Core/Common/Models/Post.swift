//
//  Post.swift
//  eBlog
//
//  Created by mac on 19/12/24.
//

import Foundation

struct Post: Decodable, Encodable, Equatable,Hashable,Identifiable  {
    let id: Int
    let authorId: Int
    let title: String
    let content: String
    let shortDescription: String
    let imgUrl: String
}
