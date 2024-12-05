//
//  Untitled.swift
//  EATAR
//
//  Created by kangweijia on 2024/11/26.
//

import UIKit
import FirebaseFirestore
import PhotosUI
import FirebaseAuth
import FirebaseStorage

class ReviewViewController: UIViewController {
    
    // MARK: - Properties
    private var reviewView: ReviewView!
    private let db = Firestore.firestore()
    
    // Properties passed from previous view controller
    private var postId: String
    private var restaurantName: String
    
    // MARK: - Initializers
    init(postId: String, restaurantName: String) {
        self.postId = postId
        self.restaurantName = restaurantName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func loadView() {
        reviewView = ReviewView()
        view = reviewView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        
    // Add cancel button
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .brown

    }
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        reviewView.titleLabel.text = "How was \(restaurantName)?"
        
        // Setup text view delegate
        reviewView.reviewTextView.delegate = self
        
        // Setup placeholder text
        reviewView.reviewTextView.text = "Write your review here..."
        reviewView.reviewTextView.textColor = .lightGray
    }
    
    private func setupActions() {
//        // Back button action
//        reviewView.backButton.addTarget(self,
//                                      action: #selector(backButtonTapped),
//                                      for: .touchUpInside)
//        
        // Submit button action
        reviewView.submitButton.addTarget(self,
                                        action: #selector(submitButtonTapped),
                                        for: .touchUpInside)
        
        // Add photo button action
        reviewView.addPhotoButton.addTarget(self,
                                          action: #selector(addPhotoButtonTapped),
                                          for: .touchUpInside)
    }
    
    // MARK: - Action Methods
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func submitButtonTapped() {
        guard validateInput() else { return }
        submitReview()
    }
    
//    @objc private func addPhotoButtonTapped() {
//        // Create image picker
//        let imagePickerController = UIImagePickerController()
//        imagePickerController.delegate = self
//        imagePickerController.sourceType = .photoLibrary
//        imagePickerController.allowsEditing = true
//        present(imagePickerController, animated: true)
//    }
    
    // MARK: - Validation Methods
    private func validateInput() -> Bool {
        // Validate ratings
        guard reviewView.foodRatingView.getCurrentRating() > 0,
              reviewView.serviceRatingView.getCurrentRating() > 0,
              reviewView.environmentRatingView.getCurrentRating() > 0 else {
            showAlert(message: "Please rate all categories")
            return false
        }
        
        // Validate review text
        let reviewText = reviewView.reviewTextView.text ?? ""
        if reviewText.isEmpty || reviewText == "Write your review here..." {
            showAlert(message: "Please write your review")
            return false
        }
        
        return true
    }
    
    // MARK: - Review Submission
    private func submitReview() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            showAlert(message: "User not logged in")
            return
        }
        
        // Create review object
        let review = Review(
            postId: postId,
            reviewerId: currentUserEmail,
            restaurantName: restaurantName,
            foodRating: reviewView.foodRatingView.getCurrentRating(),
            serviceRating: reviewView.serviceRatingView.getCurrentRating(),
            environmentRating: reviewView.environmentRatingView.getCurrentRating(),
            reviewText: reviewView.reviewTextView.text,
            photos: []  // TODO: Handle photo uploads
        )
        
        // Show loading indicator
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        // Disable submit button while processing
        reviewView.submitButton.isEnabled = false
        
        // Save to Firestore
        db.collection("reviews").document(review.id).setData(review.toFirestore()) { [weak self] error in
            guard let self = self else { return }
            
            // Hide loading indicator
            loadingIndicator.stopAnimating()
            loadingIndicator.removeFromSuperview()
            
            // Re-enable submit button
            self.reviewView.submitButton.isEnabled = true
            
            if let error = error {
                self.showAlert(message: "Error submitting review: \(error.localizedDescription)")
                return
            }
            
            // Show success message and return to previous screen
            self.showAlert(message: "Review submitted successfully") { [weak self] in
                self?.dismiss(animated: true)
            }
        }
    }
    
    // MARK: - Helper Methods
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

// MARK: - UITextViewDelegate
extension ReviewViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Write your review here..."
            textView.textColor = .lightGray
        }
    }
}
    

// MARK: - UIImagePickerControllerDelegate
// In ReviewViewController.swift
extension ReviewViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc private func addPhotoButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            // Show loading indicator
            let loadingIndicator = UIActivityIndicatorView(style: .large)
            loadingIndicator.center = view.center
            view.addSubview(loadingIndicator)
            loadingIndicator.startAnimating()
            
            // Upload to Firebase Storage
            uploadImage(image) { [weak self] url in
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
                
                if let url = url {
                    // Add to review photos array and show preview
                    self?.reviewView.addPhoto(image)
                    self?.showAlert(message: "Photo uploaded successfully")
                } else {
                    self?.showAlert(message: "Failed to upload photo")
                }
            }
        }
    }
    
    private func uploadImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.6) else {
            completion(nil)
            return
        }
        
        let storageRef = Storage.storage().reference()
        let imagePath = "review_photos/\(UUID().uuidString).jpg"
        let imageRef = storageRef.child(imagePath)
        
        // Show loading state
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        imageRef.putData(imageData, metadata: nil) { [weak self] metadata, error in
            DispatchQueue.main.async {
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
            }
            
            if let error = error {
                print("Error uploading image: \(error)")
                completion(nil)
                return
            }
            
            imageRef.downloadURL { url, error in
                if let urlString = url?.absoluteString {
                    completion(urlString)
                } else {
                    completion(nil)
                }
            }
        }
    }
}
