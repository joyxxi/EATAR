//
//  Untitled.swift
//  EATAR
//
//  Created by kangweijia on 2024/11/26.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class EditPostViewController: UIViewController {
    
    // MARK: - Properties
    private var editPostView: EditPostView!
    private let db = Firestore.firestore()
    private let postId: String
    private var originalPost: DiningPost?
    private let cuisineOptions = ["Chinese", "Japanese", "Korean", "Italian", "Mexican", "American", "Indian", "Thai"]
    private let peopleOptions = Array(2...10).map { "\($0) People" }
    private let datePicker = UIDatePicker()
    
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
        editPostView = EditPostView()
        view = editPostView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupPickers()
        fetchPostDetails()
        
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
        // Since EditPostViewController is presented modally
        dismiss(animated: true)
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        // Setup cuisine picker
        let cuisinePicker = UIPickerView()
        cuisinePicker.delegate = self
        cuisinePicker.dataSource = self
        editPostView.textFieldCuisine.inputView = cuisinePicker
        
        // Setup people picker
        let peoplePicker = UIPickerView()
        peoplePicker.delegate = self
        peoplePicker.dataSource = self
        editPostView.textFieldPeople.inputView = peoplePicker
        
        // Setup date picker
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date() // Can't select past dates
        editPostView.textFieldTime.inputView = datePicker
        
        // Setup toolbar for pickers
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([flexSpace, doneButton], animated: false)
        
        editPostView.textFieldCuisine.inputAccessoryView = toolbar
        editPostView.textFieldPeople.inputAccessoryView = toolbar
        editPostView.textFieldTime.inputAccessoryView = toolbar
    }
    
    private func setupActions() {
        editPostView.buttonSaveChanges.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
    }
    
    private func setupPickers() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    private func populateFields(with post: DiningPost) {
        editPostView.textFieldRestaurant.text = post.restaurantName
        editPostView.textFieldCuisine.text = post.cuisine
        editPostView.textFieldPeople.text = "\(post.maxPeople) People"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy HH:mm"
        editPostView.textFieldTime.text = dateFormatter.string(from: post.dateTime)
        datePicker.date = post.dateTime
        
        editPostView.textFieldLocation.text = post.location
        editPostView.textViewNote.text = post.note
        
        // Disable people field if there are already participants
        if post.currentPeople > 1 {
            editPostView.textFieldPeople.isEnabled = false
            editPostView.textFieldPeople.alpha = 0.5
        }
    }
    
    // MARK: - Action Methods
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func doneButtonTapped() {
        view.endEditing(true)
    }
    
    @objc private func dateChanged() {
        editPostView.textFieldTime.text = formatDate(datePicker.date)
    }
    
    @objc private func saveButtonTapped() {
        guard validateInput() else { return }
        saveChanges()
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
                  snapshot.exists,
                  let data = snapshot.data() else {
                self.showAlert(message: "Post not found")
                return
            }
            
            // Create post from data manually since we have DocumentSnapshot
            guard let restaurantName = data["restaurantName"] as? String,
                  let cuisine = data["cuisine"] as? String,
                  let maxPeople = data["maxPeople"] as? Int,
                  let currentPeople = data["currentPeople"] as? Int,
                  let dateTime = (data["dateTime"] as? Timestamp)?.dateValue(),
                  let location = data["location"] as? String,
                  let zipCode = data["zipCode"] as? String,
                  let note = data["note"] as? String,
                  let creatorId = data["creatorId"] as? String,
                  let participants = data["participants"] as? [String],
                  let statusRaw = data["status"] as? String,
                  let createdAt = (data["createdAt"] as? Timestamp)?.dateValue(),
                  let status = DiningPost.PostStatus(rawValue: statusRaw) else {
                self.showAlert(message: "Invalid post data")
                return
            }
            
            let post = DiningPost(
                id: snapshot.documentID,
                restaurantName: restaurantName,
                cuisine: cuisine,
                maxPeople: maxPeople,
                currentPeople: currentPeople,
                dateTime: dateTime,
                location: location,
                zipCode: zipCode,
                note: note,
                creatorId: creatorId,
                participants: participants,
                status: status,
                createdAt: createdAt
            )
            
            self.originalPost = post
            self.populateFields(with: post)
        }
    }
    
    private func saveChanges() {
        guard let currentUserEmail = Auth.auth().currentUser?.email else {
            showAlert(message: "Please log in to save changes")
            return
        }
        
        let loadingIndicator = showLoadingIndicator()
        editPostView.buttonSaveChanges.isEnabled = false
        
        // Create updated post data
        var updateData: [String: Any] = [
            "restaurantName": editPostView.textFieldRestaurant.text ?? "",
            "cuisine": editPostView.textFieldCuisine.text ?? "",
            "dateTime": Timestamp(date: datePicker.date),
            "location": editPostView.textFieldLocation.text ?? "",
            "zipCode": editPostView.textFieldZipCode.text ?? "",
            "note": editPostView.textViewNote.text ?? ""
        ]
        
        // Only update maxPeople if the field is enabled
        if editPostView.textFieldPeople.isEnabled {
            let maxPeople = extractPeopleCount(editPostView.textFieldPeople.text ?? "2 People")
            updateData["maxPeople"] = maxPeople
        }
        
        // Update in Firestore
        db.collection("posts").document(postId).updateData(updateData) { [weak self] error in
            guard let self = self else { return }
            
            loadingIndicator.stopAnimating()
            loadingIndicator.removeFromSuperview()
            self.editPostView.buttonSaveChanges.isEnabled = true
            
            if let error = error {
                self.showAlert(message: "Error saving changes: \(error.localizedDescription)")
                return
            }
            
            self.showAlert(message: "Changes saved successfully") { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - Validation Methods
    private func validateInput() -> Bool {
        // Check restaurant name
        guard let restaurant = editPostView.textFieldRestaurant.text, !restaurant.isEmpty else {
            showAlert(message: "Please enter restaurant name")
            return false
        }
        
        // Check cuisine
        guard let cuisine = editPostView.textFieldCuisine.text, !cuisine.isEmpty else {
            showAlert(message: "Please select cuisine type")
            return false
        }
        
        // Check people count
        guard let people = editPostView.textFieldPeople.text, !people.isEmpty else {
            showAlert(message: "Please select number of people")
            return false
        }
        
        // Check time
        guard let time = editPostView.textFieldTime.text, !time.isEmpty else {
            showAlert(message: "Please select time")
            return false
        }
        
        // Check location
        guard let location = editPostView.textFieldLocation.text, !location.isEmpty else {
            showAlert(message: "Please enter location")
            return false
        }
        
        // Validate date is in future
        if datePicker.date < Date() {
            showAlert(message: "Please select a future date and time")
            return false
        }
        
        return true
    }
    
    // MARK: - Helper UI Methods
    private func showLoadingIndicator() -> UIActivityIndicatorView {
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        loadingIndicator.startAnimating()
        return loadingIndicator
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
extension EditPostViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == editPostView.textFieldCuisine.inputView {
            return cuisineOptions.count
        } else {
            return peopleOptions.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == editPostView.textFieldCuisine.inputView {
            return cuisineOptions[row]
        } else {
            return peopleOptions[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == editPostView.textFieldCuisine.inputView {
            editPostView.textFieldCuisine.text = cuisineOptions[row]
        } else {
            editPostView.textFieldPeople.text = peopleOptions[row]
        }
    }
}
