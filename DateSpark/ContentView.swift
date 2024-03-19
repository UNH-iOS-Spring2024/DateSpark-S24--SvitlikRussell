//
import SwiftUI

class AppVariables: ObservableObject {
    @Published var selectedTab: Int = 0
}
struct ContentView: View {
    
    var body: some View {
        BottomBar (
            AnyView(HomeView()),
            AnyView(SparkGPTView()),
            AnyView(MapView()),
            AnyView(FriendsView()),
            AnyView(ProfileView())
        )
        .environmentObject(AppVariables())
    }
}


#Preview {
    ContentView()
}
