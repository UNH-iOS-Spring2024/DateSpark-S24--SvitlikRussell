//  SelectedPage.swift

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct SelectedPage: View {
    @State var selectedIndex: Int
    @State var index: Int
    @State var selectedTitle: String
    @State var selectedDescription: String
    @State private var selectedWeather: String = "Weather"
    @State private var selectedTimeOfDay = "Best Time"
    @State private var selectedOutfit: String = "Outfit"
    @State private var selectedTime: Date = Date()
    @State private var showingTime = false
    @State private var isSaved: Bool = false
    @State private var userId: String? = Auth.auth().currentUser?.uid
    let titleFont = Font.largeTitle.lowercaseSmallCaps()

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
    
    let db = Firestore.firestore()
    
    var body: some View {
        
        VStack{
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
                .padding(.bottom, -80)
            
            VStack{
                Text(selectedTitle)
                    .font(titleFont)
                    .bold()
                    .padding(.all, 20)
                   // .padding(.bottom, 20)
                
                Text(selectedDescription)
                    .padding(.all, 30)
                    .padding(.top, -30)
                    .lineLimit(nil)

                VStack {
                    // Menu for Weather choice
                    Menu(selectedWeather) {
                        Button("Sunny ☀️") { selectedWeather = "Sunny ☀️" }
                        Button("Rainy 🌧") { selectedWeather = "Rainy 🌧" }
                        Button("Cloudy ☁️") { selectedWeather = "Cloudy ☁️" }
                        Button("Windy 🌬") { selectedWeather = "Windy 🌬" }
                        Button("Snowy ❄️") { selectedWeather = "Snowy ❄️" }
                        Button("Foggy 🌫") { selectedWeather = "Foggy 🌫" }
                    }
                    
                    // Menu for Outfit Choice
                    Menu(selectedOutfit) {
                        Button("Casual👖") { selectedOutfit = "Casual👖" }
                        Button("Formal🎩") { selectedOutfit = "Formal🎩" }
                        Button("Fancy💃🏽") { selectedOutfit = "Fancy💃🏽" }
                        Button("Vintage👗") { selectedOutfit = "Vintage👗" }
                        Button("Streetwear👟") { selectedOutfit = "Streetwear👟" }
                        Button("Preppy💼") { selectedOutfit = "Preppy💼"}
                        Button("Minimalist🤍") { selectedOutfit = "Minimalist🤍" }
                        Button("Comfy🧣") { selectedOutfit = "Comfy🧣" }
                        Button("Artsy🎨") { selectedOutfit = "Artsy🎨" }
                        Button("Sporty🏃🏼‍♀️") { selectedOutfit = "Sporty🏃🏼‍♀️" }
                    }
                    
                    // Ideal Time
                    Menu(selectedTimeOfDay) {
                                Button("Morning🌅") { selectedTimeOfDay = "Morning🌅" }
                                Button("Noon🌇") { selectedTimeOfDay = "Noon🌇" }
                                Button("Night🌃") { selectedTimeOfDay = "Night🌃" }
                            }                                                    }
                
                        .padding(.top, -10)
                        .font(.system(size: 25))
                        .padding(.bottom, 50)
                
                Button(action: {
                    if !isSaved {
                        saveToFirebase(userId: userId ?? "")
                        isSaved.toggle()
                    }
                }) {
                    Text(isSaved ? "Date saved" : "Save Date to Archives")
                        .padding()
                        .frame(minWidth: 200, minHeight: 50) // Set a fixed frame size
                        .font(.headline)
                        .background(isSaved ? CustomColors.darkRed : CustomColors.lightPink)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, -25)

            }
            .padding(.bottom, 50)
        }
        .onAppear {
            if userId == nil {
                userId = Auth.auth().currentUser?.uid
            }
        }
    }
    
    func saveToFirebase(userId: String) {
        let data = [
            "Title": selectedTitle,
            "Outfit": selectedOutfit,
            "Weather": selectedWeather,
            "Description": selectedDescription,
            "Time": selectedTime
        ] as [String: Any]
        
        db.collection("User").document(userId).collection("Archive").addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
                isSaved = false
            } else {
                print("Document successfully added!")
                isSaved = true
            }
        }
    }
}

struct SelectedPage_Previews: PreviewProvider {
    static var previews: some View {
        SelectedPage(selectedIndex: 0, index: 1, selectedTitle: "Test Title", selectedDescription: "This is a description for previews34t34t34t34t3t4.")
    }
}
