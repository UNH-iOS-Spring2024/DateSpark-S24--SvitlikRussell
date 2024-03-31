
import SwiftUI
import Firebase

@main
struct DateSparkApp: App {
    init(){
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        FirebaseApp.configure()
        }
    @StateObject private var archiveViewModel = ArchivedViewModel() // Initialize the shared data model
    @StateObject private var appVariables = AppVariables()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appVariables)
                .environmentObject(archiveViewModel)
        }
    }
}

