//
//  BottomBar.swift
//  DateSpark-S24-Svitlik-Russell
//
//  Created by Sarah Svitlik & Shannon Russel on 03/01/24
//
import SwiftUI

struct BottomBar: View {
    @EnvironmentObject private var app: AppVariables
    let HomeView: AnyView
    let Account: AnyView
    let SparkGPT: AnyView
    let Map: AnyView
    let Friends: AnyView
    
    
    init(
        _ HomeView : AnyView,
        _ Account : AnyView,
        _ SparkGPT : AnyView,
        _ Map : AnyView,
        _ Friends : AnyView
    ){
        self.HomeView = HomeView
        self.Account = Account
        self.SparkGPT = SparkGPT // (ChatGPT view)
        self.Map = Map
        self.Friends = Friends
    }
    
    var body: some View {
        TabView(selection: $app.selectedTab){
            HomeView
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(0)
            
             SparkGPT
                .tabItem {
                    Image(systemName: "safari")
                    Text("SparkGPT")
                }
                .tag(1)
             
             Map
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
                .tag(2)
             
             Friends
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Friends")
                }
                .tag(3)
             
            Account
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
                .tag(4) 
        }
    }
}

#Preview {
    BottomBar(
        AnyView(HomeView()),
        AnyView(ProfileView()),
        AnyView(SparkGPTView()),
        AnyView(MapView()),
        AnyView(FriendsView())
    )
        .environmentObject(AppVariables())
}
