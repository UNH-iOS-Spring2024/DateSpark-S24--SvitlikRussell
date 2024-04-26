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
            HStack {
                Text("Archived Dates")
                    .font(titleFont)
            }
            
           if viewModel.archives.isEmpty {
                Text("No archives available")
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                ForEach(viewModel.archives, id: \.id) { archive in
                    VStack(alignment: .leading) {
                        Text("\(archive.title)").font(.headline).padding(.bottom, 10)
                        Text(archive.description).font(.subheadline).padding(.bottom, 10)
                        Text("Outfit: \(archive.outfit)").font(.caption)
                        Text("Weather: \(archive.weather)").font(.caption)
                        Text("Time: \(archive.time, formatter: dateFormatter)").font(.caption)
                    }
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 5)
                    .padding(.bottom, 5)
                }
            }
        }
        .background(Color.pink.edgesIgnoringSafeArea(.all))
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
