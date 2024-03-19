

import SwiftUI
import Charts
import FirebaseFirestore

struct DateData: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var outfit: String
    var time: String
    var weather: String
    var portion: Double
    var rating: Double
}

struct HomeView: View {
    @State private var isShowingPopover = false
    @State var txtchoice: String = ""
    @State var dates = [DateData]()
    
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
                
                PieChartView(dataPoints: dates)
                
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
                fetchData()
            }
        }

    struct PieChartView: View {
        let dataPoints: [DateData]

        var body: some View {

            Chart {
                ForEach (dataPoints) { d in
                    SectorMark(angle: .value("Portion", d.portion),
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

    func fetchData() {
        db.collection("Date").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents or error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.dates = documents.compactMap { queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                let title = data["title"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let outfit = data["outfit"] as? String ?? ""
                let time = data["time"] as? String ?? ""
                let weather = data["weather"] as? String ?? ""
                let portion = data["portion"] as? Double ?? 0
                let rating = data["rating"] as? Double ?? 0

                return DateData(title: title, description: description, outfit: outfit, time: time, weather: weather, portion: portion, rating: rating)
            }
        }
    }
}
 

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
