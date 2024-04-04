//  MapView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import SwiftUI
import MapKit

struct MapView: View {
    @State var location = ""
    @State private var pin: Pin?
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var detailedLocationInfo: String?
    @State private var region = MKCoordinateRegion(
        center:CLLocationCoordinate2D ( latitude: 41.292190, longitude: -72.961180 ),
        span: MKCoordinateSpan( latitudeDelta: 0.009, longitudeDelta: 0.009)
    )
    @ObservedObject var searchCompleter = SearchCompleter()
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $userTrackingMode, annotationItems: pin != nil ? [pin!] : []) { pin in
                MapAnnotation(coordinate: pin.location) {
                    PinView(pin: pin)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .overlay(alignment: .bottom) {
                if let detailedLocationInfo = detailedLocationInfo {
                    Text(detailedLocationInfo)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .padding()
                        .transition(.slide)
                }
            }

            VStack {
                TextField("Search", text: $location)
                    .onChange(of: location) { newValue in
                        searchCompleter.updateSearch(query: newValue)
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 3)
                    .padding()

                if !searchCompleter.suggestions.isEmpty {
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
                                    self.location = suggestion.title
                                    fetchLocationDetails(for: suggestion)
                                    searchCompleter.suggestions = []
                                }
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                    .background(Color.white)
                    .cornerRadius(5)
                    .shadow(radius: 5)
                }
            }
            .frame(maxWidth: .infinity, alignment: .top)
        }
    }

    func fetchLocationDetails(for suggestion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, _ in
            guard let mapItem = response?.mapItems.first else { return }
            let coordinate = mapItem.placemark.coordinate
            
            let placemark = mapItem.placemark
            region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            let name = mapItem.name ?? "Location"
            pin = Pin(location: coordinate, name: name)
            // Format the address components.
            var addressComponents = [String]()
            if let city = placemark.locality { addressComponents.append(city) }
            if let state = placemark.administrativeArea { addressComponents.append(state) }
            if let zip = placemark.postalCode { addressComponents.append(zip) }
            
            let address = addressComponents.joined(separator: ", ")
            detailedLocationInfo = "\(name) - \(address)"
        }
    }

    func search() {
        guard !location.isEmpty else { return }
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = location

        let search = MKLocalSearch(request: searchRequest)
        search.start { response, _ in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else { return }
            region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            pin = Pin(location: coordinate)
            searchCompleter.suggestions = []
        }
    }
}

struct PinView: View {
    var pin: Pin
    var body: some View {
        VStack {
            Text(pin.name)
                .font(.caption)
                .padding(5)
                .background(Color.white)
                .cornerRadius(5)
                .foregroundColor(.black)
            Image(systemName: "mappin.circle.fill")
                .font(.title)
                .foregroundColor(.red)
            Circle()
                .frame(width: 20, height: 10)
                .foregroundColor(.red)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
