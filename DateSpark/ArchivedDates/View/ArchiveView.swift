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
                
                Text("Need some ideas? Check your saved dates!")
                    .font(.system(size: 15))
                    .padding(.top, -2)
                    .padding(.bottom, 15)
                
            }
            
                if viewModel.archives.isEmpty {
                    Text("No archives available")
                        .frame(maxWidth: .infinity, alignment: .center)
                } else {
                    ForEach(viewModel.archives, id: \.id) { archive in
                        VStack(alignment: .leading) {
                            Text("\(archive.title)").font(.headline).padding(.all, 15).foregroundColor(Color.black).padding(.bottom, -20)
                            Text(archive.description).font(.subheadline).padding(.all, 15).foregroundColor(Color.black)
                            Text("Outfit: \(archive.outfit)").font(.caption).padding(.horizontal, 15).foregroundColor(Color.black)
                            Text("Weather: \(archive.weather)").font(.caption).padding(.horizontal, 15).foregroundColor(Color.black)
                            Text("Time: \(archive.time, formatter: dateFormatter)").font(.caption).padding(.horizontal, 15).padding(.bottom, 15).foregroundColor(Color.black)
                        }
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.white)))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: CustomColors.lightPink, radius: 5, x: 0, y: 0)
                        .padding(.top, 15)
                        .padding(.bottom, 15)


                    }
                    
                    .onDelete(perform: deleteFromFirebase) // Move this line here
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
