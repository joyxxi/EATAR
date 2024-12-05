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
import Firebase
import FirebaseAuth

class LocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let hasPromptedKey = "HasPromptedForLocationAccess"
    let geocoder = CLGeocoder()
    let db = Firestore.firestore()
    var currentZipCode: String?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
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
            locationManager.requestLocation()
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
        

    }
    
    // Handle changes in authorization status (optional)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           guard let location = locations.first else {
               print("Failed to get location.")
               return
           }
           
           // Use CLGeocoder to get the ZIP code
           geocoder.reverseGeocodeLocation(location) { placemarks, error in
               if let error = error {
                   print("Error during reverse geocoding: \(error.localizedDescription)")
                   return
               }
               
               if let placemark = placemarks?.first,
                  let postalCode = placemark.postalCode {
                   print("ZIP code: \(postalCode)")
                   self.currentZipCode = postalCode
                   
                   // Save ZIP code to the database or UserDefaults here
                   self.storeZipCodeInDatabase(postalCode)
               } else {
                   print("No postal code found.")
               }
           }
       }
       
       func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Failed to find user's location: \(error.localizedDescription)")
       }
       
       private func storeZipCodeInDatabase(_ zipCode: String) {
           let userEmail = Auth.auth().currentUser?.email
           guard let userEmail = userEmail else {
               print("Error: User email is nil")
               return
           }
           
           let userRef = db.collection("users").document(userEmail)
           
           userRef.updateData(["location": zipCode]) { error in
               if let error = error {
                   print("Error updating ZIP code in database: \(error.localizedDescription)")
               } else {
                   print("ZIP code successfully saved.")
               }
           }
       }
}
