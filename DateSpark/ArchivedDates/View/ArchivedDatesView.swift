//  ArchivedDatesView.swift
//  DateSpark-S24-Svitlik-Russell

import SwiftUI
import Firebase
import FirebaseFirestore

struct ArchivedDatesView: View {
    @EnvironmentObject var viewModel: ArchivedViewModel
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        List(viewModel.archivedItems) { item in
            VStack(alignment: .leading) {
                //When Generated Dates work, the Archive List will mention the Date with the rest
                /*Text(item.date)
                 .font(.headline)*/
                Text(item.outfit)
                    .font(.subheadline)
                Text(item.weather)
                    .font(.subheadline)
                Text(itemFormatter.string(from: item.time))
                    .font(.caption)
                
                HStack { //Rating
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= (item.rating ?? 0) ? "star.fill" : "star")
                            .foregroundColor(star <= (item.rating ?? 0) ? .yellow : .gray)
                            .onTapGesture {
                                viewModel.updateRating(forItemId: item.id, newRating: star)
                            }
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadData()
        }
        .navigationTitle("Archived Dates")
    }
}

struct ArchivedDatesView_Previews: PreviewProvider {
    static var previews: some View {
        ArchivedDatesView().environmentObject(ArchivedViewModel())
    }
}

