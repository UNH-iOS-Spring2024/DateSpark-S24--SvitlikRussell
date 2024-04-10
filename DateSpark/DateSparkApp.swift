import SwiftUI
import Firebase
import OpenAIKit
import UIKit


@main
struct DateSparkApp: App {
    
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ArchivedViewModel()) // Initialize the shared data model directly here
           

        }
    }
}
