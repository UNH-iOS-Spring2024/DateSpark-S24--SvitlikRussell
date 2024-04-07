//  SelectedPage.swift

import SwiftUI
import FirebaseFirestore

struct SelectedPage: View {
    
    @State var selectedIndex: Int
    @State var index: Int
    @State var selectedTitle: String
    @State var selectedDescription: String
    @State private var selectedWeather: String = "Weather"
    @State private var selectedOutfit: String = "Outfit"
    @State private var selectedTime: Date = Date()
    @State var temperature: Measurement<UnitTemperature>?

    
    //    @State private var selectedItem: DateItem?
//    @EnvironmentObject var archiveViewModel: ArchivedViewModel
    
    @State private var showingTime = false
    
        private var timeFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter
       }
    
    let db = Firestore.firestore()
    
    var body: some View {
        VStack{
            
            Text("Selected Choice:")
                .font(.system(size: 24))
            
            Text(selectedTitle)
                .font(.title)
                .underline()
                .padding(10)
            
            Text(selectedDescription)
            //take out menu and let it get the current weather
            
            
            if let temperature = temperature {
                Text("Weather: \(temperature.value) \(temperature.unit.symbol)")
            }
        
            //Menu for Weather choice
            /* Menu(selectedWeather) {
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
            } */
           // .padding(10)
            
            
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
            
                }/*.padding(30)*/
//            }
            .onAppear {
                selectDateFromFirebase(forIndex: index)
                initWeatherData()
            }
            
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
    func initWeatherData() {
        let headers = [
            "X-RapidAPI-Key": "2797d169c7msh40182f1fc10cc77p1b8166jsn644081bdb37c",
            "X-RapidAPI-Host": "weatherbit-v1-mashape.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://weatherbit-v1-mashape.p.rapidapi.com/current?lon=41&lat=73&units=metric")! as URL,
                                            cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }

            if let data = data {
                do {
                    let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    let temperatureValue = response.data.temperature
                    
                    // Update temperature data in UI
                    DispatchQueue.main.async {
                        // Check if the temperature is negative and handle accordingly
                        let formattedTemperatureValue = max(temperatureValue, 0)
                        let temperatureMeasurement = Measurement(value: formattedTemperatureValue, unit: UnitTemperature.fahrenheit)
                        self.temperature = temperatureMeasurement
                    }
                    
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()  
    }

    struct WeatherResponse: Codable {
        let data: WeatherData
    }

    struct WeatherData: Codable {
        let temperature: Double
    }

    func selectDateFromFirebase(forIndex index: Int) {
        let db = Firestore.firestore()
        let query = db.collection("Date")
            .whereField("index", isEqualTo: index)
            .limit(to: 1)
        
        query.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error in getting documents: \(error)")
            } else if let document = querySnapshot?.documents.first{
                
                let title = document.get("title") as? String ?? "N/A"
                let description = document.get("description") as? String ?? "N/A"
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
        SelectedPage(selectedIndex: 0, index: 1, selectedTitle: "Test Title", selectedDescription: "This is a description for previews.")
            .environmentObject(ArchivedViewModel())
    }
}
