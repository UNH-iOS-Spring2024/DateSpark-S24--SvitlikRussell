//
//  ArchivedDatesView.swift
//  DateSpark-S24-Svitlik-Russell
//
//  Created by Sarah Svitlik & Shannon Russel on 03/10/24
//

import SwiftUI
import Firebase
import FirebaseFirestore


struct ArchivedDatesView: View {
    @EnvironmentObject var archiveViewModel: ArchiveViewModel
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack{
            Text("Archived Dates")
                .font(.title)
                .underline()
                .padding()
            
            HStack{
                Text("Title: ")
                Text("Date: ")
                Text("Rating: ")
            }
            HStack{
                Text("Title: ")
                Text("Date: ")
                Text("Rating: ")
            }
            List(archiveViewModel.archivedItems) { item in
                Text("\(item.date, formatter: itemFormatter)")
            }
            /*var body: some View {
             VStack{
             Text("Archived Dates")
             .font(.title)
             .underline()
             .padding()
             
             HStack{
             Text("Title: ")
             Text("Date: ")
             Text("Rating: ")
             }
             HStack{
             Text("Title: ")
             Text("Date: ")
             Text("Rating: ")
             }
             } */
            
        }
    }
}
#Preview {
    ArchivedDatesView()
}
