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
    @EnvironmentObject var archiveViewModel: ArchivedDatesModel

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack {
            Text("Archived Dates")
                .font(.title)
                .underline()
                .padding()
            
            HStack {
               // Text("Title: ")
              //  Text("Date: ")
                Text("Rating: ")
            }
            
            ForEach(archiveViewModel.archivedItems) { item in
                HStack {
                   // Text(item.title),
                    //Text(dateFormatter.string(from: item.date)) // Format the date
                    Spacer()
                    Text("\(item.rating)")
                }
            }
            .padding() // Move the padding inside the VStack
        }
    }
}
                            

#Preview {
    ArchivedDatesView()
}
