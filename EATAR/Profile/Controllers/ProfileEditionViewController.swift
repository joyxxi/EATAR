//
//  ProfileEditionViewController.swift
//  EATAR
//
//  Created by NaN Wang on 11/7/24.
//

import UIKit
import PhotosUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class ProfileEditionViewController: UIViewController {
    
    let profileEditionScreen = ProfileEdition()
    var pickedImage:UIImage?
    let db = Firestore.firestore()
    let userEmail = Auth.auth().currentUser?.email
    var selectedGender = "Prefer not to say"
    var pickedImageURL:URL?
    let storage = Storage.storage()
    let notificationCenter = NotificationCenter.default
    
    override func loadView() {
        view = profileEditionScreen
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadInfo()
        
        profileEditionScreen.editProfileImageButton.menu = getMenuImagePicker()
        profileEditionScreen.editProfileImageButton.showsMenuAsPrimaryAction = true
        
        profileEditionScreen.saveButton.addTarget(self, action: #selector(onSaveButtonTapped), for: .touchUpInside)
        
        profileEditionScreen.genderSelectButton.menu = getGenderMenuTypes()

    }
    
    func loadInfo() {
        if let url = Auth.auth().currentUser?.photoURL {
            self.profileEditionScreen.loadRemoteImage(from: url)
        }
        
        guard let userEmail = userEmail else {
            print("Error: User email is nil")
            return
        }
        
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
            
            let data = document.data()
//            print("DEBUG: Profile data fetched: \(String(describing: data))")
            
            guard let data = data else { return }
            
            let profile = Profile(from: data)
            
            if let profile = profile {
                // load gender and set gender button
                self.selectedGender = profile.gender?.rawValue ?? "Prefer not to say"
                self.profileEditionScreen.genderSelectButton.setTitle(self.selectedGender, for: .normal)
                // load other info
                self.profileEditionScreen.nameTextField.text = profile.username
                self.profileEditionScreen.locationTextField.text = profile.location
                self.profileEditionScreen.cuisineTextField.text = profile.cuisinePreference
                self.profileEditionScreen.favoriteResetaurantTextField.text = profile.favoriteRestaurant
                self.profileEditionScreen.bioTextView.text = profile.bio
            }

        }
    }
    
    func uploadProfileImageToStorage() {
        guard let userEmail = userEmail else {
            print("Error: User email is nil")
            return
        }
        
        guard let image = pickedImage else {
            print("No image selected for upload. Proceeding with profile update without image.")
            updateProfile()
            return
        }
        
        guard let jpegData = image.jpegData(compressionQuality: 0.8) else {
            print("Error: Unable to convert image to JPEG data")
            return
        }
        
       let sanitizedEmail = userEmail
           .replacingOccurrences(of: "@", with: "_")
           .replacingOccurrences(of: ".", with: "_")
       let fileName = "\(sanitizedEmail).jpg"

       let storageRef = Storage.storage().reference().child("profile_pictures/\(fileName)")
        
        storageRef.putData(jpegData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                return
            }

            print("Image uploaded successfully. Retrieving download URL...")

            // Get the download URL
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("Error retrieving download URL: \(error.localizedDescription)")
                    return
                }

                guard let url = url else {
                    print("Error: Download URL is nil")
                    return
                }

                print("Download URL retrieved: \(url.absoluteString)")

                self.pickedImageURL = url
                self.setImageURLInFirebaseAuth()
            }
        }

    }
    
    func updateProfile() {
        let uwname = profileEditionScreen.nameTextField.text
        let uwgender = profileEditionScreen.genderSelectButton.titleLabel?.text
        let uwlocation = profileEditionScreen.locationTextField.text
        let uwcuisinePref = profileEditionScreen.cuisineTextField.text
        let uwfavoriteRes = profileEditionScreen.favoriteResetaurantTextField.text
        let uwbio = profileEditionScreen.bioTextView.text

//        print("DEBUG: Name: \(uwname ?? "nil"), Gender: \(uwgender ?? "nil"), Location: \(uwlocation ?? "nil"), Cuisine: \(uwcuisinePref ?? "nil"), Favorite: \(uwfavoriteRes ?? "nil"), Bio: \(uwbio ?? "nil")")
        
        // Convert gender string to enum (default to .notToSay if nil or invalid)
        let gender = uwgender.flatMap { Profile.Gender(rawValue: $0.lowercased()) } ?? .notToSay
        
        let profile = Profile(
            username: uwname ?? "Anonymous",
            gender: gender,
            location: uwlocation,
            cuisinePreference: uwcuisinePref,
            favoriteRestaurant: uwfavoriteRes,
            bio: uwbio,
            hasProfile: true
        )
        
        // Log the profile object
        print("DEBUG: Profile object: \(profile)")
        
        guard let userEmail = userEmail else {
            print("Error: User email is nil")
            return
        }
        
        let profileRef = db.collection("users").document(userEmail)
        profileRef.updateData(profile.toFirestoreData()) { error in
            if let error = error {
                print("Error saving profile: \(error.localizedDescription)")
            } else {
                print("Profile successfully saved!")
                self.notificationCenter.post(name: .finishEditingProfile, object: nil)
                self.navigationController?.popViewController(animated: true)
                //                self.hideActivityIndicator()
            }
        }
    }
    
    func setImageURLInFirebaseAuth() {
        
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.photoURL = pickedImageURL
        
        changeRequest?.commitChanges(completion: {(error) in
            if error != nil{
                print("Error occured: \(String(describing: error))")
            }else{
                self.updateProfile()
                
            }
        })
    }
        
    
    func getGenderMenuTypes() -> UIMenu {
        var menuItems = [UIAction]()
        
        for type in GenderTypes.types {
            let menuItem = UIAction(title: type,handler: {(_) in
                self.selectedGender = type
                self.profileEditionScreen.genderSelectButton.setTitle(self.selectedGender, for: .normal)
            })
            menuItems.append(menuItem)
        }
        
        return UIMenu(title: "Select Gender", children: menuItems)
    }
    

    
    @objc func onSaveButtonTapped() {
        print("Save clicked")
        uploadProfileImageToStorage()
    }
    
    func getMenuImagePicker() -> UIMenu {
        let menuItems = [
            UIAction(title: "Camera",handler: {(_) in
                self.pickUsingCamera()
            }),
            UIAction(title: "Gallery",handler: {(_) in
                self.pickPhotoFromGallery()
            })
        ]
        return UIMenu(title: "Select source", children: menuItems)
    }
    
    
    func pickUsingCamera(){
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.allowsEditing = true
        cameraController.delegate = self
        present(cameraController, animated: true)
    }
    
    func pickPhotoFromGallery(){
        var configuration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.any(of: [.images])
        configuration.selectionLimit = 1
        
        let photoPicker = PHPickerViewController(configuration: configuration)
        
        photoPicker.delegate = self
        present(photoPicker, animated: true, completion: nil)
    }



}
