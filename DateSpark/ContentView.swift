import SwiftUI

class AppVariables: ObservableObject {
    @Published var selectedTab: Int = 0
}

struct ContentView: View {
    @State private var isActive: Bool = false
    @State private var shouldNavigateToHome: Bool = false
    @State private var isLoggedIn: Bool = false
    @State private var showLoginPage: Bool = false
    
    var body: some View {
        ZStack {
            if shouldNavigateToHome {
                BottomBar(
                    AnyView(HomeView()),
                    AnyView(SparkGPTView()),
                    AnyView(MapView()),
                    AnyView(FriendsView()),
                    AnyView(ProfileView())
                )
                .environmentObject(AppVariables())
                .transition(.opacity)
            } else if showLoginPage {
                // Show login page after splash screen
                AnyView(Login(isLoggedIn: isLoggedIn))
                    .transition(.opacity)
            } else if !isActive {
                // Show splash screen initially
               AnyView(SplashScreenView(isActive: $isActive))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
//                            self.isActive = true
                            self.showLoginPage = true
                        }
                    }
                    .animation(.easeInOut, value: isActive)
                    .onChange(of: isLoggedIn) { loggedIn in
                        if loggedIn {
                            shouldNavigateToHome = true
                            showLoginPage = false
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
