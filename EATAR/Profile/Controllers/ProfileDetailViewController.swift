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
    
    override func loadView() {
        view = profileDetailScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileDetailScreen.editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    @objc func editButtonTapped() {
        let profileEditionVC = ProfileEditionViewController()
        navigationController?.pushViewController(profileEditionVC, animated: true)
    }


}
