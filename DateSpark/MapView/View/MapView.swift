//  MapView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import SwiftUI
import MapKit

struct IdentifiablePoint: Identifiable {
    let id = UUID()
    var annotation: MKPointAnnotation
}

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var searchQuery = ""
    @State private var places: [IdentifiablePoint] = []
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingDirectionsPopover = false
    @State private var directions: [String] = []
    @State private var showSuggestions = true

    var body: some View {
        ZStack(alignment: .top) {
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true, userTrackingMode: $userTrackingMode, annotationItems: places) { place in
                MapAnnotation(coordinate: place.annotation.coordinate) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .onTapGesture {
                                self.selectedPlace = place.annotation
                                self.showSuggestions = false
                            }
                        Text(place.annotation.title ?? "Unknown")
                            .foregroundColor(.black)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                viewModel.checkIfLocationServicesIsEnabled()
            }

            VStack {
                HStack {
                    TextField("Search places", text: $searchQuery, onCommit: {
                        searchLocations()
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                    Button("Search") {
                        searchLocations()
                        showSuggestions = false
                    }
                }
                .padding()

                if showSuggestions {
                    suggestionsList
                }
                Spacer()
                if let selected = selectedPlace, showingDirectionsPopover {
                    DirectionsView(directions: directions, dismissAction: {
                        showingDirectionsPopover = false
                    })
                }

                if let selectedPlace = selectedPlace, !showingDirectionsPopover {
                    Button("Get Directions") {
                        calculateDirections()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
        }
    }

    private var suggestionsList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                ForEach(places, id: \.id) { place in
                    Text(place.annotation.title ?? "Unknown")
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .onTapGesture {
                            self.searchQuery = place.annotation.title ?? ""
                            searchLocations()
                            showSuggestions = false
                        }
                }
            }
        }
        .frame(maxHeight: 200)
        .background(Color.white)
        .cornerRadius(5)
        .shadow(radius: 5)
    }

    private func searchLocations() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchQuery
        request.region = viewModel.region

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error searching locations: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.places = response.mapItems.map { item in
                let annotation = MKPointAnnotation()
                annotation.title = item.name
                annotation.coordinate = item.placemark.coordinate
                return IdentifiablePoint(annotation: annotation)
            }
        }
    }

    private func calculateDirections() {
        guard let selectedPlace = selectedPlace else { return }
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: viewModel.region.center))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: selectedPlace.coordinate))
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let response = response, let route = response.routes.first else {
                print("Error calculating directions: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
            self.showingDirectionsPopover = true
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
