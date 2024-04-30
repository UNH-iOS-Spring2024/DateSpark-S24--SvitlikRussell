//  MapView.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import SwiftUI
import MapKit

struct MapView: View {
    @State var location = ""
    @State private var pin: Pin?
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var showingLocationAlert = false
    @State private var detailedLocationInfo: String?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 41.292190, longitude: -72.961180),
        span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009)
    )
    @StateObject private var locationManager = LocationManager()
    @ObservedObject var searchCompleter = SearchCompleter()

    var body: some View {
        ZStack(alignment: .top) {
            Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $userTrackingMode, annotationItems: pin != nil ? [pin!] : []) { pin in
                MapAnnotation(coordinate: pin.location) {
                    PinView(pin: pin)
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                locationManager.requestPermission()
            }
            .alert("Location Permission Needed", isPresented: $showingLocationAlert) {
                Button("Open Settings") {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                }
            } message: {
                Text("Please allow location access in Settings to enable all features.")
            }
            .onChange(of: locationManager.lastLocation) { newLocation in
                if let newLocation = newLocation {
                    updateRegionToUserLocation(newLocation)
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
                    suggestionsList
                }
            }
            .frame(maxWidth: .infinity, alignment: .top)
        }
    }

    var suggestionsList: some View {
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

    func updateRegionToUserLocation(_ location: CLLocation) {
        let coordinate = location.coordinate
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }

    func fetchLocationDetails(for suggestion: MKLocalSearchCompletion) {
        let searchRequest = MKLocalSearch.Request(completion: suggestion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            if let error = error {
                print("Error occurred during location search: \(error.localizedDescription)")
                return
            }
            guard let mapItem = response?.mapItems.first else {
                print("No results found.")
                return
            }
            let coordinate = mapItem.placemark.coordinate
            
            let newRegion = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            DispatchQueue.main.async {
                self.region = newRegion
                self.pin = Pin(location: coordinate, name: mapItem.name ?? "Selected Location")
                self.detailedLocationInfo = mapItem.name ?? "Selected Location"
            }
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
