//  SelectedPage.swift

import SwiftUI
import FirebaseFirestore


struct SelectedPage: View {
    @State var selectedIndex: Int
    @State var index: Int
    @State var selectedTitle: String = "Title"
    @State var selectedDescription: String = "Description"
    @State private var selectedWeather: String = "Weather"
    @State private var selectedOutfit: String = "Outfit"
    @State private var selectedItem: DateItem?
    @EnvironmentObject var archiveViewModel: ArchivedViewModel
    
    @State private var showingTime = false
    @State private var selectedTime: Date = Date()
        private var timeFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter
       }
    
    let db = Firestore.firestore()
    
    var body: some View {
        VStack{
            
            Text("Selected Choice...")
                .font(.title)
 
            Text (selectedTitle)
                .font(.system(size: 24))
                .underline()
                .padding(10)
            
            Text(selectedDescription)
            
        
            //Menu for Weather choice
            Menu(selectedWeather) {
                Button(action: { selectedWeather = "Sunny" }) {
                    Label("Sunny ☀️", systemImage: "sun.max.fill")
                }
                Button(action: { selectedWeather = "Rainy" }) {
                    Label("Rainy 🌧", systemImage: "cloud.rain.fill")
                }
                Button(action: { selectedWeather = "Cloudy" }) {
                    Label("Cloudy ☁️", systemImage: "cloud.fill")
                }
                Button(action: { selectedWeather = "Windy" }) {
                    Label("Windy 🌬", systemImage: "wind")
                }
                Button(action: { selectedWeather = "Snowy" }) {
                    Label("Snowy ❄️", systemImage: "snow")
                }
                Button(action: { selectedWeather = "Foggy" }) {
                    Label("Foggy 🌫", systemImage: "cloud.fog.fill")
                }
                Button(action: { selectedWeather = "Stormy" }) {
                    Label("Stormy ⛈", systemImage: "tropicalstorm")
                }
            }
            .padding(10)
            
            
            //Menu for Outfit Choice
            Menu(selectedOutfit) {
                Button(action: { selectedOutfit = "Casual Outfit" }) {
                    Label("Casual - Everyday Comfort", systemImage: "person.fill")
                }
                Button(action: { selectedOutfit = "Formal Outfit" }) {
                    Label("Formal - Business and Events", systemImage: "briefcase.fill")
                }
                Button(action: { selectedOutfit = "Fancy Outfit" }) {
                    Label("Fancy - Elegant & Luxurious", systemImage: "star.fill")
                }
                Button(action: { selectedOutfit = "Vintage Outfit" }) {
                    Label("Vintage - Timeless Classics", systemImage: "clock.fill")
                }
                Button(action: { selectedOutfit = "Streetwear Outfit" }) {
                    Label("Streetwear - Urban & Trendy", systemImage: "paintbrush.fill")
                }
                Button(action: { selectedOutfit = "Preppy Outfit" }) {
                    Label("Preppy - Polished & Pre-collegiate", systemImage: "book.fill")
                }
                Button(action: { selectedOutfit = "Minimalist Outfit" }) {
                    Label("Minimalist - Simple & Sleek", systemImage: "rectangle.compress.vertical")
                }
                Button(action: { selectedOutfit = "Comfy Outfit" }) {
                    Label("Comfy - Cozy & Relaxed", systemImage: "bed.double.fill")
                }
                Button(action: { selectedOutfit = "Artsy Outfit" }) {
                    Label("Artsy - Creative & Unique", systemImage: "paintpalette.fill")
                }
                
            }
        
            //Ideal Time
            
            VStack {
                Button("Best Time") { showingTime = true }
                    .padding()
                    .sheet(isPresented: $showingTime) {
                        VStack {
                            DatePicker(
                                "Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute
                            )
                            .datePickerStyle(WheelDatePickerStyle())
                            .labelsHidden()
                            
                            Text("Selected time: \(timeFormatter.string(from: selectedTime))")
                                .padding()
                            
                            Button("Done") {
                                showingTime = false
                            }
                        }
                    }
                Text("Selected time: \(timeFormatter.string(from: selectedTime))")
//                Button("Save") {
//                    userToFirebase()
//                    if let itemToSave = selectedItem {
//                    archiveViewModel.add(item: itemToSave) }
//            
                }.padding(30)
//            }
            
            
        }
        .font(.system(size: 25))
    }
    func userToFirebase(){
        let data = [
//            "Description" : Description, //Need to figure out how to append a generated description
                    "Outfit" : selectedOutfit,
                    "Weather" : selectedWeather,
                    "Time" : selectedTime] as [String : Any]
        
        var ref: DocumentReference? = nil
        ref = db.collection("Archive").addDocument(data: data) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                
            }
        }
    }
    
    func selectDateFromFirebase(forIndex index: Int) {
        let db = Firestore.firestore()
        let query = db.collection("Date")
            .whereField("index", isEqualTo: index)
            .limit(to: 1)
        
        query.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error in getting documents: \(error)")
            } else {
                guard let document = querySnapshot?.documents.first else {
                    print("Document not found")
                    return
                }
                let title = document["title"] as? String ?? ""
                          let description = document["description"] as? String ?? ""
                          let weather = document["weather"] as? String ?? ""
                          let outfit = document["outfit"] as? String ?? ""
                          let time = (document["time"] as? Timestamp)?.dateValue() ?? Date()
                
                self.selectedTitle = title
                self.selectedDescription = description
                self.selectedWeather = weather
                self.selectedOutfit = outfit
                self.selectedTime = time
             }
        }
    }

    
}



struct SelectedPage_Previews: PreviewProvider {
    static var previews: some View {
        SelectedPage(selectedIndex: 0, index: 1)
            .environmentObject(ArchivedViewModel())
    }
}
