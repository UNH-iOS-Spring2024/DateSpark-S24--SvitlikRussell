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
        self.completer?.resultTypes = [.address, .pointOfInterest]
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        let filteredSuggestions = completer.results.filterDuplicates()
        self.suggestions = completer.results
    }
    
    func updateSearch(query: String) {
        completer?.queryFragment = query
    }
}
extension Array where Element == MKLocalSearchCompletion {
    func filterDuplicates() -> [MKLocalSearchCompletion] {
        var addedDict = [String: Bool]()
        
        return filter {
            let key = "\($0.title)-\($0.subtitle)"
            if addedDict[key] == nil {
                addedDict[key] = true
                return true
            } else {
                return false
            }
        }
    }
}
