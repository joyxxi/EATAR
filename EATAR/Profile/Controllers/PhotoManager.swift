//
//  PhotoManager.swift
//  EATAR
//
//  Created by NaN Wang on 11/27/24.
//

import UIKit
import PhotosUI
import FirebaseStorage

extension ProfileEditionViewController:PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        print(results)
        
        let itemprovider = results.map(\.itemProvider)
        
        for item in itemprovider{
            if item.canLoadObject(ofClass: UIImage.self){
                item.loadObject(
                    ofClass: UIImage.self,
                    completionHandler: { (image, error) in
                        DispatchQueue.main.async{
                            if let uwImage = image as? UIImage{
                                self.profileEditionScreen.profileImage.image = uwImage.withRenderingMode(.alwaysOriginal)
                                self.pickedImage = uwImage
                            }
                        }
                    }
                )
            }
        }
    }
}

extension ProfileEditionViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage{
            self.profileEditionScreen.profileImage.image = image.withRenderingMode(.alwaysOriginal)
            self.pickedImage = image
        }else{
        }
    }
}

