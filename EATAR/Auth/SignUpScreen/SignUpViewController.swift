import UIKit
import FirebaseAuth
import FirebaseFirestore

class SignupViewController: UIViewController {
    
    private var signupView: SignupView!
    private let db = Firestore.firestore()
    
    override func loadView() {
        signupView = SignupView()
        self.view = signupView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
    }
    
    private func setupActions() {
        signupView.buttonSignUp.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }
    
    @objc private func signUpTapped() {
        guard let username = signupView.textfieldName.text, !username.isEmpty,
              let email = signupView.textfieldEmail.text, !email.isEmpty,
              let password = signupView.textfieldPassword.text, !password.isEmpty,
              let confirmPassword = signupView.textfieldConfirmPassword.text, !confirmPassword.isEmpty else {
            showAlert(title: "Error", message: "Please fill out all fields.")
            return
        }
        
        // Validate email format
        guard isValidEmail(email) else {
            showAlert(title: "Invalid Email", message: "Please enter a valid email address.")
            return
        }
        
        // Validate password length
        guard password.count >= 6 && password.count <= 4096 else {
            showAlert(title: "Invalid Password", message: "Password must be between 6 and 4096 characters.")
            return
        }
        
        // Validate matching passwords
        guard password == confirmPassword else {
            showAlert(title: "Error", message: "Passwords do not match.")
            return
        }
        
        signUpUser(email: email, password: password, username: username)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func signUpUser(email: String, password: String, username: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(title: "Sign Up Failed", message: error.localizedDescription)
                return
            }
            
            guard let user = authResult?.user else {
                self.showAlert(title: "Sign Up Failed", message: "Unexpected error occurred.")
                return
            }
            
            // Update the user profile with the username
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = username
            changeRequest.commitChanges { error in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    return
                }
                
                // Add user to Firestore database
                self.addUserToFirestore(email: email, username: username) {
                    // Automatically log in the user
                    self.loginUser(email: email, password: password)
                }
            }
        }
    }
    
    private func addUserToFirestore(email: String, username: String, completion: @escaping () -> Void) {
        let userDocument: [String: Any] = [
            "email": email,
            "username": username,
            "createdAt": Timestamp(date: Date()),
            "hasProfile": false
        ]
        
        db.collection("users").document(email).setData(userDocument) { error in
            if let error = error {
                self.showAlert(title: "Error", message: "Failed to add user to database: \(error.localizedDescription)")
                return
            }
            
            completion()
        }
    }
    
    private func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(title: "Login Failed", message: error.localizedDescription)
                return
            }
            
            // TODO: remove after adding redirects in fetchUserProfile()
            self.showAlert(title: "Success", message: "Account created and logged in successfully!") {
                // Replace this with navigation to your main app screen
                self.navigationController?.popToRootViewController(animated: true)
            }
            self.fetchUserProfile(email: email)
        }
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
