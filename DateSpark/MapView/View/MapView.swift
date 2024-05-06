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
    @StateObject private var locationManager = LocationManager()
    @StateObject private var searchCompleter = SearchCompleter()
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.292190, longitude: -72.961180),
        span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
    )
    @State private var searchQuery = ""
    @State private var places: [IdentifiablePoint] = []
    @State private var selectedPlace: MKPointAnnotation?
    @State private var showingDirectionsPopover = false
    @State private var directions: [String] = []
    @State private var showSuggestions = true

    var body: some View {
        ZStack(alignment: .top) {
            Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $userTrackingMode, annotationItems: places) { place in
                MapAnnotation(coordinate: place.annotation.coordinate) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .onTapGesture {
                                self.selectedPlace = place.annotation
                                self.showSuggestions = false // Hide suggestions when a place is selected
                            }
                        Text(place.annotation.title ?? "Unknown")
                            .foregroundColor(.black)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onChange(of: locationManager.lastLocation) { newLocation in
                updateRegionToUserLocation(newLocation)
            }
            .onAppear {
                locationManager.requestPermission()
            }
            
            VStack {
                HStack {
                    TextField("Search places", text: $searchQuery, onEditingChanged: { _ in }, onCommit: {
                        searchLocations()
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width:250, height:10)
                    .onChange(of: searchQuery) { newValue in
                        searchCompleter.updateSearch(query: newValue)
                        showSuggestions = true // Show suggestions while typing
                    }

                    Button(action: {
                        searchLocations()
                        showSuggestions = false // Hide suggestions when search is manually triggered
                    }) {
                        Text("Search")
                            .bold()
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(minWidth: 100, minHeight: 32)
                            .background(CustomColors.lightPink)
                            .cornerRadius(10)

                    }
                }
                .cornerRadius(10)

                if showSuggestions && !searchCompleter.suggestions.isEmpty {
                    suggestionsList
                }

                if showingDirectionsPopover, let selected = selectedPlace {
                    DirectionsView(directions: directions, dismissAction: {
                        showingDirectionsPopover = false
                    })
                }

                if let selectedPlace = selectedPlace, !showingDirectionsPopover {
                    Button("Get Directions") {
                        calculateDirections()
                        
                    }
                    .bold()
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(minWidth: 150, minHeight: 32)
                    .background(CustomColors.lightPink)
                    .cornerRadius(10)
                    .popover(isPresented: $showingDirectionsPopover) {
                        DirectionsView(directions: directions) {
                            showingDirectionsPopover = false
                        }
                    }
                    .padding(.top, 43)

                }
            }
        }
    }

    private var suggestionsList: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading) {
                ForEach(searchCompleter.suggestions, id: \.self) { suggestion in
                    VStack(alignment: .leading) {
                        Text(suggestion.title) // Location name or primary address
                            .fontWeight(.bold)
                        Text(suggestion.subtitle) // City, state, and ZIP
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .onTapGesture {
                        self.searchQuery = suggestion.title
                        searchLocations()
                        showSuggestions = false // Hide suggestions after selection
                    }
                }
            }
        }
        .frame(maxHeight: 200)
        .background(Color.white)
        .cornerRadius(5)
        .shadow(radius: 5)
    }

    private var directionsList: some View {
        List(directions, id: \.self) { direction in
            Text(direction)
        }
        .transition(.slide)
        .animation(.easeInOut, value: showingDirectionsPopover)
    }

    private func updateRegionToUserLocation(_ location: CLLocation?) {
        guard let location = location else { return }
        region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    private func searchLocations() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchQuery
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription ?? "Unknown error").")
                return
            }
            self.places = response.mapItems.map { item in
                let annotation = MKPointAnnotation()
                annotation.title = item.name
                annotation.coordinate = item.placemark.coordinate
                return IdentifiablePoint(annotation: annotation)
            }
            if let firstLocation = response.mapItems.first?.placemark.coordinate {
                self.region.center = firstLocation
            }
        }
    }

    private func calculateDirections() {
        guard let selectedPlace = selectedPlace,
              let userLocation = locationManager.lastLocation else { return }

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: selectedPlace.coordinate))
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let response = response else {
                print("Error: \(error?.localizedDescription)")
                return
            }

            self.directions = response.routes.first?.steps.map { $0.instructions }.filter { !$0.isEmpty } ?? []
            self.showingDirectionsPopover = true
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
