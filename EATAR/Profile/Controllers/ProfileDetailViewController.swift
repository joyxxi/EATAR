//
//  ProfileDetailViewController.swift
//  EATAR
//
//  Created by NaN Wang on 11/7/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ProfileDetailViewController: UIViewController {

    let profileDetailScreen = ProfileDetail()
    let db = Firestore.firestore()
    let userEmail = Auth.auth().currentUser?.email
    let notificationCenter = NotificationCenter.default
    
    override func loadView() {
        view = profileDetailScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileDetailScreen.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        loadInfo()
        
        notificationCenter.addObserver(self, selector: #selector(handleInfoRelaod), name: .finishEditingProfile, object: nil)

    }
    
    @objc func handleInfoRelaod() {
        loadInfo()
    }
    
    func loadInfo() {
        // Load profile image
        if let url = Auth.auth().currentUser?.photoURL {
            self.profileDetailScreen.loadRemoteImage(from: url)
        }
        
        guard let userEmail = userEmail else {
            print("Error: User email is nil")
            return
        }
        
        // load other info
        let profileRef = db.collection("users").document(userEmail)
        
        profileRef.getDocument { (document, error) in
                if let error = error {
                    print("Error fetching profile: \(error.localizedDescription)")
                    return
                }
                
                // Check if the document exists
                guard let document = document, document.exists else {
                    print("Profile document does not exist.")
                    return
                }
                
                // Parse the document data into a Profile object
                let data = document.data()
//                print("DEBUG: Profile data fetched: \(String(describing: data))")
                
                guard let data = data else { return }
                
                // Map Firestore data to Profile object
            let profile = Profile(from: data)
            
            if let profile = profile {
                self.profileDetailScreen.nameLabel.text = "Username: " + (profile.username ?? "")
                self.profileDetailScreen.genderLabel.text = "Gender: " + (profile.gender?.rawValue ?? "")
                self.profileDetailScreen.locationLabel.text = "Location: " + (profile.location ?? "")
                self.profileDetailScreen.cuisinePreferenceLabel.text = "Cuisine Preferences: " + (profile.cuisinePreference ?? "")
                self.profileDetailScreen.favoriteRestaurantLabel.text = "Favorite Restaurant: " + (profile.favoriteRestaurant ?? "")
                self.profileDetailScreen.bioLabel.text = "Bio: " + (profile.bio ?? "")
            }

            }
        
    }
    
    @objc func editButtonTapped() {
        let profileEditionVC = ProfileEditionViewController()
        navigationController?.pushViewController(profileEditionVC, animated: true)
    }


}
