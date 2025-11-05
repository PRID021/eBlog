// AppDelegate.swift
import UserNotifications
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    let notificationManager = NotificationManager() // Single shared instance
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.delegate = notificationManager // Use NotificationManager as delegate
        let category = UNNotificationCategory(identifier: "RICH_NOTIFICATION", actions: [], intentIdentifiers: [], options: [])
        center.setNotificationCategories([category])
        
        // Register for remote notifications
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        UserDefaults.standard.set(tokenString, forKey: "apnsToken")
        UserDefaults.standard.set(tokenString, forKey: "apnsToken")
        print("APNs token saved: \(tokenString)")
    }
    
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
}
