//  ArchiveView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import SwiftUI
import Firebase
import FirebaseAuth

struct ArchiveView: View {
    @ObservedObject var viewModel: ArchiveViewModel
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()

    var body: some View {
        List {
           if viewModel.archives.isEmpty {
                Text("No archives available")
           } else {
               ForEach(viewModel.archives, id: \.id) { archive in
                   VStack(alignment: .leading) {
                       Text("Date: \(archive.title)").font(.headline)
                       Text(archive.description).font(.subheadline)
                       Text("Outfit: \(archive.outfit)").font(.caption)
                       Text("Weather: \(archive.weather)").font(.caption)
                       Text("Time: \(archive.time, formatter: dateFormatter)").font(.caption)
                   }
               }
           }
        }
        .onAppear {
            viewModel.observeAuthChanges()
        }
    }
}


struct ArchiveView_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveView(viewModel: ArchiveViewModel())
    }
}

