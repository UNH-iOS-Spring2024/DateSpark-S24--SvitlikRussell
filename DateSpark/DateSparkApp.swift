
import SwiftUI
import Firebase

@main
struct DateSparkApp: App {
    init(){
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        FirebaseApp.configure()
        }
    @StateObject private var archiveViewModel = ArchiveViewModel() // Initialize the shared data model

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(archiveViewModel)
        }
    }
}

