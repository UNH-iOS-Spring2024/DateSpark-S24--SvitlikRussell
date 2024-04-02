//  SearchCompleter.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import Foundation
import MapKit

class SearchCompleter: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var suggestions: [MKLocalSearchCompletion] = []
    var completer: MKLocalSearchCompleter?
    
    override init() {
        super.init()
        self.completer = MKLocalSearchCompleter()
        self.completer?.delegate = self
        self.completer?.resultTypes = .address // Customize based on the type of searches you want
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        self.suggestions = completer.results
    }
    
    func updateSearch(query: String) {
        completer?.queryFragment = query
    }
}
