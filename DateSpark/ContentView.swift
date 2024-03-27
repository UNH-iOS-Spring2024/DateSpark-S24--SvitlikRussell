//
import SwiftUI

class AppVariables: ObservableObject {
    @Published var selectedTab: Int = 0
}
struct ContentView: View {
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            if isActive {
                BottomBar(
                    AnyView(HomeView()),
                    AnyView(SparkGPTView()),
                    AnyView(MapView()),
                    AnyView(FriendsView()),
                    AnyView(ProfileView())
                )
                .environmentObject(AppVariables())
                .transition(.opacity)
            }
            if !isActive {
                SplashScreenView(isActive: $isActive)
            }
        }
        .animation(.easeInOut, value: isActive) // Animate the transition
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
