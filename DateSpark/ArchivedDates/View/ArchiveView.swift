//  ArchiveView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import SwiftUI
import Firebase
import FirebaseAuth

struct ArchiveView: View {
    @ObservedObject var viewModel: ArchiveViewModel
    let titleFont = Font.largeTitle.lowercaseSmallCaps()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        List {
            VStack {
                Text("Archived Dates")
                    .font(titleFont)
                    .padding(.top, 15)
                    .bold()
                    .foregroundColor(CustomColors.beige)
                
                Text("Check your saved dates for ideas. 💕")
                    .font(.system(size: 15))
                    .padding(.top, -2)
                    .padding(.bottom, 15)
                    .padding(.horizontal, 15)
                
            }
            
                if viewModel.archives.isEmpty {
                    Text("No archives available")
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ForEach(viewModel.archives, id: \.id) { archive in
                        VStack(alignment: .leading) {
                            Text("\(archive.title)").font(.title2).padding(.all, 15).foregroundColor(Color.white).padding(.bottom, -20).frame(maxWidth: .infinity).multilineTextAlignment(.center).bold()
                            Text(archive.description).font(.subheadline).padding(.all, 20).foregroundColor(Color.white)
                            Text("Outfit: \(archive.outfit)").font(.subheadline).padding(.horizontal, 20).foregroundColor(Color.white)
                            Text("Weather: \(archive.weather)").font(.subheadline).padding(.horizontal, 20).foregroundColor(Color.white)
                            Text("Time: \(archive.time)").font(.subheadline).padding(.horizontal, 20).padding(.bottom, 20).foregroundColor(Color.white)
                        }
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(CustomColors.lightPink)))
                        .frame(width: 300, height: 250)
                        
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: CustomColors.brown, radius: 5, x: 0, y: 0)
                        .padding(.top, -10)
                        .padding(.bottom, -10)


                    }
                    
                    .onDelete(perform: deleteFromFirebase) 
                }
        }
        .padding(.top, -30)
        .background(Color.pink.edgesIgnoringSafeArea(.all))
        .onAppear {
            viewModel.observeAuthChanges()
        }
    }
    
    func deleteFromFirebase (at offsets: IndexSet) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Error: No current user")
            return
        }
        
        let db = Firestore.firestore()
        for index in offsets {
            let archive = viewModel.archives[index]
            
            db.collection("User").document(userID).collection("Archive").document(archive.id).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    DispatchQueue.main.async {
                        self.viewModel.archives.remove(at: index)
                    }
                }
            }
        }
    }

}


struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView(viewModel: ArchiveViewModel())
    }
}
