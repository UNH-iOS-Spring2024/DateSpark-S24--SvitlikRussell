// ContentView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell
import SwiftUI
import OpenAIKit

class AppVariables: ObservableObject {
    @Published var selectedTab: Int = 0
    @Published var isLoggedIn: Bool = false
    @Published var isSignedOut: Bool = false
}


struct ContentView: View {
    init () {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    @State private var isActive: Bool = false
    @State private var shouldNavigateToHome: Bool = false
    @State private var isLoggedIn: Bool = false
    @State private var showLoginPage: Bool = false
    @EnvironmentObject var appVariables: AppVariables
    
    var body: some View {
        ZStack {
            if appVariables.isLoggedIn{
                BottomBar(
                    AnyView(HomeView()),
                    AnyView(SparkGPTView()),
                    AnyView(MapView()),
                    AnyView(FriendsListView()),
                    AnyView(ProfileView())
                )
                .environmentObject(AppVariables())
                .transition(.opacity)

            } else if showLoginPage {
                AnyView(Login(isLoggedIn: $isLoggedIn))
                    .transition(.opacity)
            } else if !isActive {
                AnyView(SplashScreenView(isActive: $isActive))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
                            // After SplashScreen, proceed to show the LoginPage.
                            self.appVariables.isLoggedIn = false
                          self.showLoginPage = true
                        }
                    }
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: isActive)
        .onChange(of: isActive) { loggedIn in
            if loggedIn {
                shouldNavigateToHome = true
                showLoginPage = false
            }
        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppVariables())
    }
}
