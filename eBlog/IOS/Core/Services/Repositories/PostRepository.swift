//
//  PostRepository.swift
//  eBlog
//
//  Created by mac on 19/12/24.
//

import Foundation


class PostRepository {
    
    func getPosts( completion: @escaping (Result<Array<Post>, Error>) -> Void) {
        // Create the AuthEndpoint instance
        let getPostsRequest = GetPostsRequest()
        
        // Perform the request using Alamofire's Request extension
        getPostsRequest.performRequest(baseURL: PostApiEndpoint.baseURL) { result in
            switch result {
            case .success(let posts):
                completion(.success(posts))  // Login successful
            case .failure(let error):
                completion(.failure(error))  // Error in login
            }
        }
    }
}
