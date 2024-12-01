//
//  ViewController.swift
//  EATAR
//
//  Created by NaN Wang on 10/31/24.
//

import UIKit

class ViewController: UIViewController {

    let landingPageScreen = LandingPageView()
    let signinScreen = SignInView()
    let signupScreen = SignupView()
    
    override func loadView() {
        view = landingPageScreen
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        PostStatusService.shared.checkAndUpdateCompletedPostsOnAppLaunch()
        
        landingPageScreen.loginButton.addTarget(self, action: #selector(onButtonLoginTapped), for: .touchUpInside)
        
        landingPageScreen.signupButton.addTarget(self, action: #selector(onButtonSignupTapped), for: .touchUpInside)
    }
    
    @objc func onButtonLoginTapped(){
        let signinScreen = SignInViewController()
        navigationController?.pushViewController(signinScreen, animated: true)
    }
    
    @objc func onButtonSignupTapped(){
        let signupScreen = SignupViewController()
        navigationController?.pushViewController(signupScreen, animated: true)
    }

}

