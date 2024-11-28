//
//  UpdateProfileReminder.swift
//  EATAR
//
//  Created by NaN Wang on 11/27/24.
//

import UIKit

func showUpdateProfileReminder(on viewController: UIViewController) {
    let alert = UIAlertController(
        title: "Update Your Profile",
        message: "Keep your profile up to date for the best experience!",
        preferredStyle: .actionSheet
    )
    alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { _ in
        navigateToProfileEdition(from: viewController)
    }))
    alert.addAction(UIAlertAction(title: "Update Later", style: .cancel, handler: nil))
    
    viewController.present(alert, animated: true, completion: nil)
}

func navigateToProfileEdition(from viewController: UIViewController) {
    if let navigationController = viewController.navigationController {
        print("Navigating to Update Profile Page")
        let profileEditionVC = ProfileEditionViewController()
        navigationController.pushViewController(profileEditionVC, animated: true)
    } else {
        print("Error: error occurred when navigating to profile edition vc.")
    }
}
