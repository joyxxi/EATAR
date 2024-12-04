//
//  LocationManager.swift
//  EATAR
//
//  Created by NaN Wang on 11/27/24.
//

// MARK: Used to manage the location access:
//  1. when user logged in for the first time
//  2. when user click for locations in the profile

import CoreLocation
import UIKit

class LocationManager {
    let locationManager = CLLocationManager()
    let hasPromptedKey = "HasPromptedForLocationAccess"
    
    func checkLocationAuthorization() {
        
        let hasPrompted = UserDefaults.standard.bool(forKey: hasPromptedKey)
        let currentStatus = locationManager.authorizationStatus
        
        switch currentStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            if !hasPrompted {
                showLocationSettingsAlert()
                UserDefaults.standard.set(true, forKey: hasPromptedKey)
            }
        case .authorizedAlways, .authorizedWhenInUse:
            print("Location access granted.")
        @unknown default:
            fatalError("Unhandled case for location authorization status.")
        }

    }
    
    private func showLocationSettingsAlert() {
        let alert = UIAlertController(
            title: "Location Access Needed", message: "Please enable location access to enjoy full feature.", preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        })
        
        if let topController = UIApplication.shared.windows.first?.rootViewController {
            topController.present(alert, animated: true, completion: nil)
        }
        
        // Handle changes in authorization status (optional)
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization()
        }
    }
}
