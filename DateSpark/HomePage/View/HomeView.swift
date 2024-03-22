//
//  ContentView.swift
//  DateSpark-S24-Svitlik-Russell
//
//  Created by Sarah Svitlik & Shannon Russel on 3/01/24
//

import SwiftUI
import Charts
import FirebaseFirestore

struct HomeView: View {
    @State private var isShowingPopover = false
    @State var txtchoice: String = ""
    @State private var wheelAngle: Double = 0
    @State var dates: [DateClass] = []
    @State private var isSpinning = false
    private var db = Firestore.firestore()
    
    var body: some View {
        NavigationView{
            VStack {
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: ArchivedDatesView().environmentObject(ArchivedViewModel())){
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
                
                VStack {
                    PieChartView(dataPoints: $dates)
                        .rotationEffect(.degrees(wheelAngle))
                }
 

                VStack{
                    Button(action: {
                        print("Button to start the wheel has been pressed")
                        let randomAngle = Double.random(in: 0...360) //create random angle for the wheel
                        let rotations = Int.random(in: 2...5) //random number of wheel rotations
                        let totalRotation = 360.0 * Double(rotations) + randomAngle  
                        withAnimation(.easeInOut(duration: 3.0)) {
                            self.wheelAngle += totalRotation
                        }
                        withAnimation(.easeInOut(duration: 1.5)) {
                            self.isSpinning.toggle() // Toggle spinning state
                        }
                    }) {
                        Image(systemName: "triangle")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.purple)
                            .padding(.bottom, 40)
                    }
                }
                
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
                                            // Declare dataToAdd here so that it's accessible throughout the closure
                                            let dataToAdd: [String: Any] = ["title": self.txtchoice, "date": Date()]
                                            print("Add Button pressed")
                                            addDate(userId: "userID", data: dataToAdd)
                                            getDatesFromFirebase()
                                            self.txtchoice = ""
                                            self.isShowingPopover = false
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
            .padding(.bottom, 30)
        }
    }
    
    func getDatesFromFirebase() {
        db.collection("Date").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                // Clear the dates array before appending new items
                self.dates.removeAll()
                
                for document in querySnapshot!.documents {
                    print("\(document.documentID)")
                    if let dateitem = DateClass(id: document.documentID, data: document.data()) {
                        self.dates.append(dateitem)
                    }
                }
            }
        }
    }
 }

func addDate(userId: String, data: [String : Any]) {
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("Date").addDocument(data: data) {err in
            if let err = err {
                print ("Error adding document: \(err)")
                } else {
                        print ("Document added with ID: \(ref!.documentID)")
                    }
                }
            }

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


#Preview {
    ContentView()
}
