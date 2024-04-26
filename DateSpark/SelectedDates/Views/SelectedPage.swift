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
        ZStack(alignment: .topTrailing) {
            Button(action: {
                if !isSaved {
                    saveToFirebase(userId: userId ?? "")
                }
                isSaved.toggle() // Toggle saved state
            }) {
                Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(isSaved ? .pink : .primary)
            }
            .padding()
            
            VStack{
                Text(selectedTitle)
                    .font(titleFont)
                    .bold()
                    .padding(10)
                
                Text(selectedDescription)
                
                // Menu for Weather choice
                Menu(selectedWeather) {
                    Button("Sunny ☀️") { selectedWeather = "Sunny" }
                    Button("Rainy 🌧") { selectedWeather = "Rainy" }
                    Button("Cloudy ☁️") { selectedWeather = "Cloudy" }
                    Button("Windy 🌬") { selectedWeather = "Windy" }
                    Button("Snowy ❄️") { selectedWeather = "Snowy" }
                    Button("Foggy 🌫") { selectedWeather = "Foggy" }
                    Button("Stormy ⛈") { selectedWeather = "Stormy" }
                }
                .padding(10)
                
                // Menu for Outfit Choice
                Menu(selectedOutfit) {
                    Button("Casual Outfit - Everyday Comfort") { selectedOutfit = "Casual Outfit" }
                    Button("Formal Outfit - Business and Events") { selectedOutfit = "Formal Outfit" }
                    Button("Fancy Outfit - Elegant & Luxurious") { selectedOutfit = "Fancy Outfit" }
                    Button("Vintage Outfit - Timeless Classics") { selectedOutfit = "Vintage Outfit" }
                    Button("Streetwear Outfit - Urban & Trendy") { selectedOutfit = "Streetwear Outfit" }
                    Button("Preppy Outfit - Polished & Pre-collegiate") { selectedOutfit = "Preppy Outfit" }
                    Button("Minimalist Outfit - Simple & Sleek") { selectedOutfit = "Minimalist Outfit" }
                    Button("Comfy Outfit - Cozy & Relaxed") { selectedOutfit = "Comfy Outfit" }
                    Button("Artsy Outfit - Creative & Unique") { selectedOutfit = "Artsy Outfit" }
                }
                
                // Ideal Time
                VStack {
                    Button("Best Time") { showingTime = true }
                        .padding()
                        .sheet(isPresented: $showingTime) {
                            DatePicker(
                                "Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute
                            )
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            
                            Text("Selected time: \(timeFormatter.string(from: selectedTime))")
                                .padding()
                            
                            Button("Done") { showingTime = false }
                        }
                    Text("Selected time: \(timeFormatter.string(from: selectedTime))")
                }
                .padding(.all)
            }
            .font(.system(size: 25))
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
        SelectedPage(selectedIndex: 0, index: 1, selectedTitle: "Test Title", selectedDescription: "This is a description for previews.")
    }
}
