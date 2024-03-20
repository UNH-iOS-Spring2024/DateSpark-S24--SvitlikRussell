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
                
                VStack{
                    Button (action: {
                        print("Button to start the wheel has been pressed")
                        // Get this to cause the wheel to spin
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
            .padding(.bottom, 30)
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

