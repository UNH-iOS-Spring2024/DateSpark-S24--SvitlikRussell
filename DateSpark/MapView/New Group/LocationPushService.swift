// LocationPushService.swift
//  DateSpark-S24-Svitlik-Russell
//  Sarah Svitlik & Shannon Russell

import CoreLocation
import UserNotifications

class LocationPushService: UNNotificationServiceExtension, CLLocationPushServiceExtension, CLLocationManagerDelegate {

    var completion: (() -> Void)?
    var locationManager: CLLocationManager?

    func didReceiveLocationPushPayload(_ payload: [String : Any], completion: @escaping () -> Void) {
        self.completion = completion
        self.locationManager = CLLocationManager()
        self.locationManager!.delegate = self
        self.locationManager!.requestLocation()
    }
    
    func serviceExtensionWillTerminate() {
        self.completion?()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.completion?()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.completion?()
    }

}
