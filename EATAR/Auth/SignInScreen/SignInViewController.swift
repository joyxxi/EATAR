import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignInViewController: UIViewController {

    private var signInView: SignInView!
    private let db = Firestore.firestore()

    override func loadView() {
        signInView = SignInView()
        self.view = signInView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }

    private func setupActions() {
        // Add target actions for buttons
        signInView.buttonSignIn.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        signInView.buttonSignUp.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        let forgotPasswordTap = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTapped))
        signInView.labelForgotPassword.addGestureRecognizer(forgotPasswordTap)
        signInView.labelForgotPassword.isUserInteractionEnabled = true
    }

    @objc private func signInTapped() {
        guard let email = signInView.textFieldUsername.text, !email.isEmpty,
              let password = signInView.textFieldPassword.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter both email and password.")
            return
        }
//      print(email, password)
        // Sign in using Firebase Auth
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }

            if let error = error {
                self.showAlert(title: "Login Failed", message: error.localizedDescription)
                return
            }

            // Fetch hasProfile field after sign-in
            self.fetchUserProfile(email: email)
            // temporary access to home screen since profile data is not available
            let homeScreenVC = HomeScreenViewController()
            self.navigationController?.pushViewController(homeScreenVC, animated: true)
            
        }
    }

    @objc private func signUpTapped() {
        // Navigate to the Sign-Up screen
        let signUpVC = SignupViewController() // Replace with your actual sign-up controller
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }

    @objc private func forgotPasswordTapped() {
        // Handle forgot password logic
        let alertController = UIAlertController(title: "Reset Password",
                                                message: "Enter your email to receive reset instructions.",
                                                preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }
        let resetAction = UIAlertAction(title: "Send", style: .default) { _ in
            guard let email = alertController.textFields?.first?.text, !email.isEmpty else {
                self.showAlert(title: "Error", message: "Please enter your email.")
                return
            }
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    self.showAlert(title: "Success", message: "Password reset instructions sent!")
                }
            }
        }
        alertController.addAction(resetAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

    private func fetchUserProfile(email: String) {
            db.collection("users").document(email).getDocument { [weak self] snapshot, error in
                guard let self = self else { return }

                if let error = error {
                    print("Error fetching user profile: \(error.localizedDescription)")
                    self.showAlert(title: "Error", message: "Could not fetch user profile.")
                    return
                }

                guard let data = snapshot?.data(), let hasProfile = data["hasProfile"] as? Bool else {
                    print("hasProfile field not found for user \(email)")
                    return
                }

                print("hasProfile for user \(email): \(hasProfile)")

                if hasProfile {
                    // TODO: redirect to the main page if there's a profile
                    self.showAlert(title: "Welcome!", message: "Welcome back!")
                    // Pop HomeScreen
                    let homeScreenVC = HomeScreenViewController()
                    self.navigationController?.pushViewController(homeScreenVC, animated: true)
                } else {
                    // TODO: redirect to ProfileEdition page if there's no profile
//                    let profileDetailVC = ProfileEditionController()
//                    self.navigationController?.pushViewController(profileDetailVC, animated: true)
                }
            }
        }

    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completion?()
        }))
        present(alert, animated: true, completion: nil)
    }
}
