import SwiftUI

@main
struct YourAppNameApp: App {
    init() {
        // Add custom fonts
        for fontName in ["DarkerGrotesque-Regular", "DarkerGrotesque-Medium", "DarkerGrotesque-SemiBold", "DarkerGrotesque-Bold"] {
            if let fontURL = Bundle.main.url(forResource: fontName, withExtension: "ttf") {
                CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
