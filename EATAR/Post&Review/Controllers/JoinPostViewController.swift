//
//  Untitled.swift
//  EATAR
//
//  Created by kangweijia on 2024/11/26.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class JoinPostViewController: UIViewController {
    
    // MARK: - Properties
    private var joinPostView: JoinPostView!
    private let db = Firestore.firestore()
    private let postId: String
    private var post: DiningPost?
    private var isParticipating: Bool = false
    
    // MARK: - Initializers
    init(postId: String) {
        self.postId = postId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func loadView() {
        joinPostView = JoinPostView()
        view = joinPostView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        fetchPostDetails()
    }
    
    // MARK: - Setup Methods
    private func setupActions() {
        joinPostView.backButton.addTarget(self,
                                        action: #selector(backButtonTapped),
                                        for: .touchUpInside)
        joinPostView.joinButton.addTarget(self,
                                        action: #selector(joinButtonTapped),
                                        for: .touchUpInside)
        joinPostView.leaveButton.addTarget(self,
                                         action: #selector(leaveButtonTapped),
                                         for: .touchUpInside)
    }
    
    private func updateUI(with post: DiningPost) {
        joinPostView.titleLabel.text = "Join Me at \(post.restaurantName)"
        joinPostView.restaurantInfoLabel.text = "Restaurant: \(post.restaurantName)"
        joinPostView.cuisineLabel.text = "Cuisine: \(post.cuisine)"
        joinPostView.peopleLabel.text = "People: \(post.currentPeople)/\(post.maxPeople)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy HH:mm"
        joinPostView.timeLabel.text = "Time: \(dateFormatter.string(from: post.dateTime))"
        joinPostView.locationLabel.text = "Location: \(post.location)"
        joinPostView.zipCodeLabel.text = "Zip Code: \(post.zipCode)"
        
        // Check if current user is participating
        if let currentUserEmail = Auth.auth().currentUser?.email {
            isParticipating = post.participants.contains(currentUserEmail)
            updateButtonsState()
        }
    }
    
    private func updateButtonsState() {
        joinPostView.joinButton.isEnabled = !isParticipating && post?.currentPeople ?? 0 < post?.maxPeople ?? 0
        joinPostView.leaveButton.isEnabled = isParticipating
        
        // Update button colors based on state
        joinPostView.joinButton.backgroundColor = joinPostView.joinButton.isEnabled ? .systemBrown : .systemGray
        joinPostView.leaveButton.backgroundColor = joinPostView.leaveButton.isEnabled ? .systemBrown : .systemGray
    }
    
    // MARK: - Action Methods
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func joinButtonTapped() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            showAlert(message: "Please log in to join")
            return
        }
        
        joinPost(userEmail: currentUserEmail)
    }
    
    @objc private func leaveButtonTapped() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            showAlert(message: "Please log in to leave")
            return
        }
        
        leavePost(userEmail: currentUserEmail)
    }
    
    // MARK: - Firebase Methods
    private func fetchPostDetails() {
        let loadingIndicator = showLoadingIndicator()
        
        db.collection("posts").document(postId).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            loadingIndicator.stopAnimating()
            loadingIndicator.removeFromSuperview()
            
            if let error = error {
                self.showAlert(message: "Error fetching post details: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot,
                  let post = DiningPost.fromFirestore(snapshot as! QueryDocumentSnapshot) else {
                self.showAlert(message: "Post not found")
                return
            }
            
            self.post = post
            self.updateUI(with: post)
        }
    }
    
    private func joinPost(userEmail: String) {
        let loadingIndicator = showLoadingIndicator()
        disableButtons()
        
        let postRef = db.collection("posts").document(postId)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let postDocument: DocumentSnapshot
            do {
                try postDocument = transaction.getDocument(postRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let post = postDocument.data(),
                  let currentPeople = post["currentPeople"] as? Int,
                  let maxPeople = post["maxPeople"] as? Int,
                  var participants = post["participants"] as? [String] else {
                return nil
            }
            
            // Validate post isn't full
            guard currentPeople < maxPeople else {
                let error = NSError(domain: "PostError", code: -1,
                                  userInfo: [NSLocalizedDescriptionKey: "Post is full"])
                errorPointer?.pointee = error
                return nil
            }
            
            // Add participant
            participants.append(userEmail)
            
            transaction.updateData([
                "participants": participants,
                "currentPeople": currentPeople + 1
            ], forDocument: postRef)
            
            return nil
        }) { [weak self] (_, error) in
            guard let self = self else { return }
            
            loadingIndicator.stopAnimating()
            loadingIndicator.removeFromSuperview()
            self.enableButtons()
            
            if let error = error {
                self.showAlert(message: "Error joining post: \(error.localizedDescription)")
                return
            }
            
            self.isParticipating = true
            self.post?.currentPeople += 1
            self.post?.participants.append(userEmail)
            
            if let post = self.post {
                self.updateUI(with: post)
            }
            
            self.showAlert(message: "Successfully joined the dining experience!")
        }
    }
    
    private func leavePost(userEmail: String) {
        let loadingIndicator = showLoadingIndicator()
        disableButtons()
        
        let postRef = db.collection("posts").document(postId)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let postDocument: DocumentSnapshot
            do {
                try postDocument = transaction.getDocument(postRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let post = postDocument.data(),
                  let currentPeople = post["currentPeople"] as? Int,
                  var participants = post["participants"] as? [String] else {
                return nil
            }
            
            // Remove participant
            participants.removeAll { $0 == userEmail }
            
            transaction.updateData([
                "participants": participants,
                "currentPeople": currentPeople - 1
            ], forDocument: postRef)
            
            return nil
        }) { [weak self] (_, error) in
            guard let self = self else { return }
            
            loadingIndicator.stopAnimating()
            loadingIndicator.removeFromSuperview()
            self.enableButtons()
            
            if let error = error {
                self.showAlert(message: "Error leaving post: \(error.localizedDescription)")
                return
            }
            
            self.isParticipating = false
            self.post?.currentPeople -= 1
            self.post?.participants.removeAll { $0 == userEmail }
            
            if let post = self.post {
                self.updateUI(with: post)
            }
            
            self.showAlert(message: "Successfully left the dining experience")
        }
    }
    
    // MARK: - Helper Methods
    private func showLoadingIndicator() -> UIActivityIndicatorView {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        return loadingIndicator
    }
    
    private func disableButtons() {
        joinPostView.joinButton.isEnabled = false
        joinPostView.leaveButton.isEnabled = false
    }
    
    private func enableButtons() {
        updateButtonsState()
    }
    
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        
        present(alert, animated: true)
    }
}