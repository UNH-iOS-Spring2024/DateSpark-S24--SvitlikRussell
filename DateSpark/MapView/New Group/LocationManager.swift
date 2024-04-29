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
                    let showingLocationAlert = true
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
        lastLocation = locations.last
    }
}

