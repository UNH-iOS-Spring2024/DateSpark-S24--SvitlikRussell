
//  HomeView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import SwiftUI
import Charts
import FirebaseFirestore
import FirebaseAuth

extension Color {
    static let lightBeige = Color(red: 203/255, green: 195/255, blue: 187/255)
    static let brown = Color(red: 66/255, green: 36/255, blue: 0/255)
    static let lightPink = Color(red: 235/255, green: 135/255, blue: 149/255)
    static let darkRed = Color(red: 234/255, green: 93/255, blue: 81/255)
    static let beige = Color(red: 66/255, green: 0/255, blue: 0/255)
}


struct HomeView: View {
    @State private var isShowingPopover = false
    @State var txtchoice: String = ""
    @State private var wheelAngle: Double = 0
    @State var dates: [DateClass] = []
    @State private var isSpinning = false
    @State private var selectedDate: DateClass?
    @State var index = 0
    @State var selectedIndex = -1 //index for firebase selected date
    @State private var showSelectedDateButton = false
    @State var feedbackMessage: String = ""
    @State var showingLocationAlert = false
//    @State var userId: String
    @State private var userId: String? = Auth.auth().currentUser?.uid
    private let db = Firestore.firestore()
    
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    NavigationLink(destination: ArchivedDatesView().environmentObject(ArchivedViewModel(userId: "yourUserId"))) {
                        Image(systemName: "archivebox.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(.lightPink)
                    }
                    .padding(.top, 40)
                    .padding(.trailing, 20)
                }
                
                Spacer()
                
                HStack {
                    Text("Random Date")
                        .font(.system(size: 35))
                }
                .padding(.bottom, 50)
                .padding(.top, 50)
                
                Spacer()
                
                // Your Pie Chart with dataPoints
                VStack {
                    PieChartView(dataPoints: $dates)
                        .rotationEffect(.degrees(wheelAngle))
                }
                
                VStack {
                    Button(action: {
                        print("Button to start the wheel has been pressed")
                        spinWheel()
                    }) {
                        Image(systemName: "triangle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.darkRed)
                    }
                    Spacer()
                }
                
                //after hitting the show selected date button:
                if showSelectedDateButton{
                    VStack {
                        NavigationLink(destination: SelectedPage(selectedIndex: selectedIndex,
                                                                 index: index,
                                                                 selectedTitle: selectedDate?.title ?? "Title",
                                                                 selectedDescription: selectedDate?.description ?? "Description")) {
                            Text("Show selected date")
                                .frame(maxWidth: 300)
                            //.frame(maxHeight: 100)
                                .padding()
                                .background(Color.black)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
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
                            .foregroundColor(.lightPink)
                            .popover(isPresented: $isShowingPopover) {
                                NavigationView {
                                    VStack {
                                        TextField("Enter a date to the wheel", text: $txtchoice)
                                            .padding()
                                        
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            let dataToAdd: [String: Any] = ["title": self.txtchoice, "date": Date()]
                                            print("Add Button pressed")
                                            addDate(userId: userId ?? "DefaultUserId", data: dataToAdd)
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
                                    .navigationBarTitle("Add Date", displayMode: .inline)
                                    .navigationBarItems(trailing: Button("Done") {
                                        self.isShowingPopover = false
                                    })
                                }
                            }
                    }
                }
                
                .padding(.bottom, 100)
                .padding(.trailing, 20)
            }
            
        }
        
        .onAppear {
            getDatesFromFirebase()
        }
    }
    
    struct PieChartView: View {
        @Binding var dataPoints: [DateClass]
        
        private let colors: [Color] = [
            .lightBeige,
            .brown,
            .lightPink,
            .darkRed,
            .beige
        ]
        
        var body: some View {
            VStack {
                Chart {
                    ForEach(dataPoints.indices, id: \.self) { index in
                        let colorIndex = index % colors.count
                        let date = dataPoints[index]
                        SectorMark(angle: .value("portion", date.portion),
                                   innerRadius: .ratio(0), // Set inner radius to zero
                                   angularInset: 3.5)
                        .cornerRadius(35)
                        .foregroundStyle(colors[colorIndex])
                    }
                }
                .frame(width: 300, height: 300)
            }
            .padding(.bottom, 50)
        }
    }
    
    
    //Spins the wheel after hitting the triangle
    func spinWheel(){
        showSelectedDateButton = false
        let randomAngle = Double.random(in: 0...360)
        let rotations = Int.random(in: 2...5) //random number of wheel spins from 2-5
        let totalRotation = 360.0 * Double(rotations) + randomAngle
        withAnimation(.easeInOut(duration: 3.0)) {
            self.wheelAngle += totalRotation
        }
        withAnimation(.easeInOut(duration: 1.5)) {
            self.isSpinning.toggle()
        }
        //Below is to match up the index given in the app to the index given in the firebase pulls for the dates
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            let index = calculateIndexFromAngle(self.wheelAngle)
            self.index = selectedIndex
            self.selectedIndex = index
            selectedDate = dates[selectedIndex]
            self.showSelectedDateButton = true
            print("Index: \(index)")
        }
        
    }
    
    func calculateIndexFromAngle(_ angle: Double) -> Int {
        return Int.random(in: 0..<dates.count)
    }
    
    func getDatesFromFirebase() {
        db.collection("Date").limit(to: 5).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.dates.removeAll()
                for document in querySnapshot!.documents {
                    print("\(document.documentID)")
                    if let dateitem = DateClass(id: document.documentID, data: document.data(), title: document.get("title") as? String ?? "", index: index, userId: userId ?? "") {
                        self.dates.append(dateitem)
                        selectedIndex += 1
                        print("Document with index of \(index)")
                    }
                }
            }
        }
    }
    
    
    //Add date after hitting the plus button
    func addDate(userId: String, data: [String : Any]) {
        let db = Firestore.firestore()
        db.collection("Date").addDocument(data: data) { [self] error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added successfully")
                
                // Create a new DateClass instance and add it to the dates array
                if let dateitem = DateClass(id: "", data: data, title: data["title"] as? String ?? "", index: index, userId: userId) {
                    self.dates.append(dateitem)
                    selectedIndex += 1
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
