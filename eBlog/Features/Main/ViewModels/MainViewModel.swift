//
//  MainViewModel.swift
//  eBlog
//
//  Created by mac on 19/12/24.
//

import Foundation
import UserNotifications

class MainViewModel: ObservableObject {
    @Published var isGetFailed: Bool = false
    @Published var isLoading: Bool = false
    @Published var featurings: Array<Featuring> = []
    
    // Notification-related properties
    @Published var isPermissionGranted = false
    @Published var showSettingsAlert = false
    
    // Tab index
    @Published var selectedTab = 0
    
    private var landingRepository: LandingRepository
    private let notificationManager = NotificationManager()
    
    init(landingRepository: LandingRepository = LandingRepository()) {
        self.landingRepository = landingRepository
    }
    
    // Fetch featurings
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
    
    // Notification permission handling
    func requestPermissionIfNeeded() {
        notificationManager.requestNotificationPermission { [weak self] granted in
            DispatchQueue.main.async {
                self?.isPermissionGranted = granted
                if !granted {
                    self?.notificationManager.checkPermissionStatus()
                    self?.showSettingsAlert = !(self?.notificationManager.isPermissionGranted ?? false)
                }
            }
        }
    }
    
    func scheduleNotification() {
        notificationManager.scheduleNotification(
            title: "eBlog Update",
            body: "New content available!",
            timeInterval: 5
        )
    }
}
