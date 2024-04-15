//
//  BottomBar.swift
//  DateSpark-S24-Svitlik-Russell
//
//  Created by Sarah Svitlik & Shannon Russel on 03/01/24
//
import SwiftUI
import OpenAIKit

struct BottomBar: View {
    @EnvironmentObject private var app: AppVariables
    let HomeView: AnyView
    let SparkGPT: AnyView
    let Map: AnyView
    let Friends: AnyView
    let Account: AnyView

    
    
    init(
        _ HomeView : AnyView,
        _ SparkGPT : AnyView,
        _ Map : AnyView,
        _ Friends : AnyView,
        _ Account : AnyView
    ){
        self.HomeView = HomeView
        self.SparkGPT = SparkGPT // (ChatGPT view)
        self.Map = Map
        self.Friends = Friends
        self.Account = Account
    }
    
    var body: some View {
        TabView(selection: $app.selectedTab){
            HomeView
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
                .tag(1)
            
             SparkGPT
                .tabItem {
                    Image(systemName: "safari")
                    Text("SparkGPT")
                }
                .tag(2)
             
             Map
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
                .tag(3)
             
             Friends
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Friends")
                }
                .tag(4)
             
            Account
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
                .tag(5)
        }
    }
}

#Preview {
    BottomBar(
        AnyView(HomeView()),
        AnyView(SparkGPTView()),
        AnyView(MapView()),
        AnyView(FriendsListView()),
        AnyView(ProfileView())
    )
        .environmentObject(AppVariables())
}
