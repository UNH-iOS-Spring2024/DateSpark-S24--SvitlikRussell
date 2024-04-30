//  CoreLocation.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import Foundation
import CoreLocation
import UserNotifications

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var lastLocation: CLLocation?
    @Published var authorizationStatus = CLAuthorizationStatus.notDetermined
    @Published var showingLocationAlert = false


    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = true
    }

    func requestPermission() {
        locationManager.requestWhenInUseAuthorization() //Always ask permission
        let currentStatus = CLLocationManager.authorizationStatus()
            if currentStatus == .notDetermined {
                locationManager.requestAlwaysAuthorization()
            } else if currentStatus == .authorizedWhenInUse {
                locationManager.requestAlwaysAuthorization()
            } else if currentStatus == .denied {
                // Handle the case when the user has previously denied permission.
                DispatchQueue.main.async {
                    self.showingLocationAlert = true
                }
            }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.authorizationStatus = status
            if status == .authorizedAlways  {
                self.locationManager.startUpdatingLocation()
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        DispatchQueue.main.async {
            self.lastLocation = newLocation  // Always update with the latest location
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}


