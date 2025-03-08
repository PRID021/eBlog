//
//  MainViewModel.swift
//  eBlog
//
//  Created by mac on 19/12/24.
//

import Foundation


class MainViewModel : ObservableObject {
    @Published var isGetFailed: Bool = false
    @Published var isLoading: Bool = false

    @Published var featurings: Array<Featuring> = []
    
    private var landingRepository: LandingRepository

    init(landingRepository: LandingRepository = LandingRepository()) {
        self.landingRepository = landingRepository
    }
    
    func handleGetFeaturings() {
        isLoading = true
        isGetFailed = false
        landingRepository.getFeaturings { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let featurings):
                    self?.featurings = featurings
                case .failure(_):
                    self?.isGetFailed = true
                }
            }
        }
    }
}
