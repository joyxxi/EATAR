//
//  SignInViewController.swift
//  EATAR
//
//  Created by Yogi Yu on 11/6/24.
//

import UIKit

class SignInViewController: UIViewController {
    
    let signinScreen = SignInView()
    let signupScreen = SignupView()
    
    override func loadView() {
        view = signinScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        signinScreen.buttonSignUp.addTarget(self, action: #selector(onButtonSignUpTapped), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func onButtonSignUpTapped(){
        let signupScreen = SignUpViewController()
        navigationController?.pushViewController(signupScreen, animated: true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
