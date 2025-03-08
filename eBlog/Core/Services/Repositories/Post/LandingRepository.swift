//
//  PostRepository.swift
//  eBlog
//
//  Created by mac on 19/12/24.
//

import Foundation


class LandingRepository {
    
    func getFeaturings( completion: @escaping (Result<Array<Featuring>, Error>) -> Void) {
        let getFeaturingsRequest = GetFeaturingsRequest()
        getFeaturingsRequest.performRequest(baseURL: FeaturingApiEndpoint.baseURL) { result in
            switch result {
            case .success(let featurings):
                completion(.success(featurings))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
