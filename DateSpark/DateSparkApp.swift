import SwiftUI
import Firebase

@main
struct DateSpark_S24_Svitlik_RussellApp: App {
    init(){
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        FirebaseApp.configure()
        }
    @StateObject private var archiveViewModel = ArchivedViewModel()  

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(archiveViewModel)
        }
    }
}
