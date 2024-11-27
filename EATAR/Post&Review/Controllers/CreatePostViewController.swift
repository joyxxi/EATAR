//
//  Untitled.swift
//  EATAR
//
//  Created by kangweijia on 2024/11/26.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CreatePostViewController: UIViewController {
    
    // MARK: - Properties
    private var createPostView: CreatePostView!
    private let db = Firestore.firestore()
    private let cuisineOptions = ["Chinese", "Japanese", "Korean", "Italian", "Mexican", "American", "Indian", "Thai"]
    private let peopleOptions = Array(2...10).map { "\($0) People" }
    private let datePicker = UIDatePicker()
    
    // MARK: - Lifecycle Methods
    override func loadView() {
        createPostView = CreatePostView()
        view = createPostView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupPickers()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        // Setup cuisine picker
        let cuisinePicker = UIPickerView()
        cuisinePicker.delegate = self
        cuisinePicker.dataSource = self
        createPostView.textFieldCuisine.inputView = cuisinePicker
        
        // Setup people picker
        let peoplePicker = UIPickerView()
        peoplePicker.delegate = self
        peoplePicker.dataSource = self
        createPostView.textFieldPeople.inputView = peoplePicker
        
        // Setup date picker
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date() // Can't select past dates
        createPostView.textFieldTime.inputView = datePicker
        
        // Setup toolbar for pickers
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: false)
        
        createPostView.textFieldCuisine.inputAccessoryView = toolbar
        createPostView.textFieldPeople.inputAccessoryView = toolbar
        createPostView.textFieldTime.inputAccessoryView = toolbar
    }
    
    private func setupActions() {
        createPostView.buttonPost.addTarget(self, action: #selector(postButtonTapped), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    private func setupPickers() {
        // Add tap gesture to dismiss keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Action Methods
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func doneButtonTapped() {
        view.endEditing(true)
    }
    
    @objc private func dateChanged() {
        createPostView.textFieldTime.text = formatDate(datePicker.date)
    }
    
    @objc private func postButtonTapped() {
        guard validateInput() else { return }
        createPost()
    }
    
    // MARK: - Helper Methods
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy HH:mm"
        return formatter.string(from: date)
    }
    
    private func extractPeopleCount(_ peopleString: String) -> Int {
        return Int(peopleString.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) ?? 2
    }
    
    // MARK: - Validation Methods
    private func validateInput() -> Bool {
        // Check restaurant name
        guard let restaurant = createPostView.textFieldRestaurant.text, !restaurant.isEmpty else {
            showAlert(message: "Please enter restaurant name")
            return false
        }
        
        // Check cuisine
        guard let cuisine = createPostView.textFieldCuisine.text, !cuisine.isEmpty else {
            showAlert(message: "Please select cuisine type")
            return false
        }
        
        // Check people count
        guard let people = createPostView.textFieldPeople.text, !people.isEmpty else {
            showAlert(message: "Please select number of people")
            return false
        }
        
        // Check time
        guard let time = createPostView.textFieldTime.text, !time.isEmpty else {
            showAlert(message: "Please select time")
            return false
        }
        
        // Check location
        guard let location = createPostView.textFieldLocation.text, !location.isEmpty else {
            showAlert(message: "Please enter location")
            return false
        }
        
        return true
    }
    
    // MARK: - Post Creation
    private func createPost() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            showAlert(message: "User not logged in")
            return
        }
        
        // Create post object
        let post = DiningPost(
            restaurantName: createPostView.textFieldRestaurant.text ?? "",
            cuisine: createPostView.textFieldCuisine.text ?? "",
            maxPeople: extractPeopleCount(createPostView.textFieldPeople.text ?? "2 People"),
            dateTime: datePicker.date,
            location: createPostView.textFieldLocation.text ?? "",
            zipCode: createPostView.textFieldZipCode.text ?? "",
            note: createPostView.textViewNote.text ?? "",
            creatorId: currentUserEmail
        )
        
        // Show loading indicator
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        
        // Disable post button while processing
        createPostView.buttonPost.isEnabled = false
        
        // Save to Firestore
        db.collection("posts").document(post.id).setData(post.toFirestore()) { [weak self] error in
            guard let self = self else { return }
            
            // Hide loading indicator
            loadingIndicator.stopAnimating()
            loadingIndicator.removeFromSuperview()
            
            // Re-enable post button
            self.createPostView.buttonPost.isEnabled = true
            
            if let error = error {
                self.showAlert(message: "Error creating post: \(error.localizedDescription)")
                return
            }
            
            // Show success message and return to previous screen
            self.showAlert(message: "Post created successfully") { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
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

// MARK: - UIPickerViewDelegate & DataSource
extension CreatePostViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == createPostView.textFieldCuisine.inputView {
            return cuisineOptions.count
        } else {
            return peopleOptions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == createPostView.textFieldCuisine.inputView {
            return cuisineOptions[row]
        } else {
            return peopleOptions[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == createPostView.textFieldCuisine.inputView {
            createPostView.textFieldCuisine.text = cuisineOptions[row]
        } else {
            createPostView.textFieldPeople.text = peopleOptions[row]
        }
    }
}
