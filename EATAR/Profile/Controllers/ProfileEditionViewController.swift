//
//  ProfileEditionViewController.swift
//  EATAR
//
//  Created by NaN Wang on 11/7/24.
//

import UIKit
import PhotosUI

class ProfileEditionViewController: UIViewController {
    
    let profileEditionScreen = ProfileEdition()
    var pickedImage:UIImage?
    
    override func loadView() {
        view = profileEditionScreen
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileEditionScreen.editProfileImageButton.menu = getMenuImagePicker()
        profileEditionScreen.editProfileImageButton.showsMenuAsPrimaryAction = true

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
