//
//  Untitled.swift
//  eBlog
//
//  Created by mac on 13/3/25.
//

import Foundation
import SwiftUI
import SwiftUICore

import UIKit

struct DeviceInfo: Codable {
    // APNs and Device Identification
    let deviceToken: String         // APNs token as hex string
    let deviceId: String?           // Unique device identifier (if available)
    
    // Device Hardware Info
    let deviceName: String          // User-assigned device name (e.g., "John's iPhone")
    let modelName: String           // Hardware model (e.g., "iPhone 14")
    let modelIdentifier: String     // Specific identifier (e.g., "iPhone15,2")
    
    // Software Info
    let osName: String              // Operating system name (e.g., "iOS")
    let osVersion: String           // OS version (e.g., "17.4")
    let appVersion: String          // App version (e.g., "1.2.3")
    let buildNumber: String         // Build number (e.g., "123")
    
    // System Info
    let language: String            // Preferred language (e.g., "en-US")
    let timezone: String            // Timezone identifier (e.g., "America/New_York")
    let isSimulator: Bool           // Whether running on simulator
    
    // Capabilities
    let pushEnabled: Bool           // Whether push notifications are enabled
    let isJailbroken: Bool          // Basic jailbreak detection
    
    init(deviceToken: Data) {
        // APNs Token
        self.deviceToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        
        // Device Identification
        self.deviceId = UIDevice.current.identifierForVendor?.uuidString
        
        // Hardware Info
        self.deviceName = UIDevice.current.name
        self.modelName = UIDevice.current.model
        self.modelIdentifier = UIDevice.modelIdentifier() // Custom method below
        
        // Software Info
        self.osName = UIDevice.current.systemName
        self.osVersion = UIDevice.current.systemVersion
        self.appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
        self.buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
        
        // System Info
        self.language = Locale.preferredLanguages.first ?? "Unknown"
        self.timezone = TimeZone.current.identifier
        #if targetEnvironment(simulator)
        self.isSimulator = true
        #else
        self.isSimulator = false
        #endif

        // Capabilities
        self.pushEnabled = UIApplication.shared.isRegisteredForRemoteNotifications
        self.isJailbroken = DeviceInfo.isJailbroken() // Custom method below
    }
    
    // Helper method to get detailed model identifier
    private static func isJailbroken() -> Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        // Basic jailbreak checks
        let paths = [
            "/Applications/Cydia.app",
            "/private/var/stash",
            "/bin/bash",
            "/usr/sbin/sshd"
        ]
        
        return paths.contains { FileManager.default.fileExists(atPath: $0) }
        #endif
    }
}

// Extension to get precise model identifier
extension UIDevice {
    static func modelIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
