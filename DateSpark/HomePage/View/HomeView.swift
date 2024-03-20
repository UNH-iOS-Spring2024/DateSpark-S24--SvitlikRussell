//
//  ContentView.swift
//  DateSpark-S24-Svitlik-Russell
//
//  Created by Sarah Svitlik & Shannon Russel on 3/01/24
//

import SwiftUI
import Charts
import FirebaseFirestore

class DateClass: ObservableObject{
    
    var id: String
    
    @Published var title: String
    @Published var description: String
    @Published var outfit: String
    @Published var time: String
    @Published var weather: String
    @Published var portion: Double
    @Published var rating: String

    required init?(id: String, data: [String: Any]) {
              let title = data["title"] as? String != nil ? data["title"] as! String : ""
              let description = data["description"] as? String != nil ? data["description"] as! String : ""
              let outfit = data["outfit"] as? String != nil ? data["outfit"] as! String : ""
              let time = data["time"] as? String != nil ? data["time"] as! String : ""
              let weather = data["weather"] as? String != nil ? data["weather"] as! String : ""
              let portion = data["portion"] as? Double != nil ? data["portion"] as! Double : 50
              let rating = data["rating"] as? String != nil ? data["rating"] as! String : ""


        self.id = id
        self.title = title
        self.description = description
        self.outfit = outfit
        self.time = time
        self.weather = weather
        self.portion = portion
        self.rating = rating
    }
}

struct HomeView: View {
    @State private var isShowingPopover = false
    @State var txtchoice: String = ""
    
    @State var dates: [DateClass] = []
    
    private var db = Firestore.firestore()
    
    var body: some View {
        NavigationView{
            VStack {
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: ArchivedDatesView()){
                        Image(systemName: "archivebox")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(.pink)
                    }
                    .padding(.top, 20)
                    .padding(.trailing, 20)
                }
                
                HStack {
                    Text("Random Date")
                        .font(.system(size: 40))
                }
                .padding(.top, 100)
                
                PieChartView(dataPoints: $dates)
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        self.isShowingPopover = true
                        print("Add date button pressed.")
                        
                    }) {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                            .popover(isPresented: $isShowingPopover) {
                                NavigationView { // Embed in NavigationView
                                    VStack {
                                        TextField("Enter a date to the wheel", text: $txtchoice)
                                            .padding()
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            print("Add Buton pressed")
                                        }) {
                                            Text ("Add Date")
                                                .frame(maxWidth: 100)
                                                .padding()
                                                .background(Color.blue)
                                                .foregroundColor(.white)
                                                .cornerRadius(10)
                                        }
                                    }
                                    .navigationBarTitle("Add Date", displayMode: .inline) // Set navigation bar title
                                    .navigationBarItems(trailing: Button("Done") {
                                        self.isShowingPopover = false
                                    })
                                }
                            }
                    }
                }
                
                .padding(.bottom, 20)
                .padding(.trailing, 20)
            }
        }
        
        .onAppear {
            getDatesFromFirebase()
        }
    }
    
    struct PieChartView: View {
        @Binding var dataPoints: [DateClass]

        var body: some View {
            Chart {
                ForEach(dataPoints.indices, id: \.self) { index in
                    SectorMark(angle: .value("portion", self.dataPoints[index].portion),
                               innerRadius: .ratio(0.618),
                               angularInset: 3.5)
                        .cornerRadius(35)
                        .foregroundStyle(Color.pink)
                }
            }
            .padding()
            .padding(.bottom, 70)
        }
    }
    
    func getDatesFromFirebase() {
        db.collection("Date")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID)")
                        if let dateitem = DateClass(id: document.documentID, data: document.data()) { // Corrected the class name to DateModel
                            self.dates.append(dateitem)
                        }
                    }
                }
            }
    }


    
    
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView()
        }
    }
}

