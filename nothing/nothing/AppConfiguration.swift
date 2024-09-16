import Foundation

enum AppConfiguration {
    static var appName: String {
        "nothing"
    }
    
    static var bundleIdentifier: String {
        "ak.nothing"
    }
    
    static var appVersion: String {
        "1.0"
    }
    
    static var buildNumber: String {
        "1"
    }
    
    // Add any other configuration items you need here
}

// Extension to access these values from anywhere in your app
extension Bundle {
    static var appName: String {
        AppConfiguration.appName
    }
    
    static var appVersion: String {
        AppConfiguration.appVersion
    }
    
    static var buildNumber: String {
        AppConfiguration.buildNumber
    }
}
