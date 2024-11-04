//
//  ProfileEdition.swift
//  EATAR
//
//

import UIKit

class ProfileEdition: UIView {
    var scrollView: UIScrollView!
    var profileImage: UIImageView!
    var editProfileImageButton: UIButton!
    var nameLabel: UILabel!
    var nameTextField: UITextField!
    var genderLabel: UILabel!
    var genderSelectButton: UIButton!
    var locationLabel: UILabel!
    var locationTextField: UITextField!
    var cuisinePreferenceLabel: UILabel!
    var cuisineTextField: UITextField!
    var cuisineTableView: UITableView!
    var bioLabel: UILabel!
    var bioTextView: UITextView!
    var saveButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupScrollView()
        setupProfileImage()
        setupEditProfileImageButton()
        setupNameLabel()
        setupNameTextField()
        setupGenderLabel()
        setupGenderSelectButton()
        setupLocationLabel()
        setupLocationTextField()
        setupCuisinePreferenceLabel()
        setupCuisineTextField()
        setupCusineTableView()
        setupBioLabel()
        setupBioTextView()
        setupSaveButton()
        
        initConstraints()
    }
    
    func setupSaveButton() {
        saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(saveButton)
    }
    
    func setupBioTextView() {
        bioTextView = UITextView()
        bioTextView.isEditable = true
        bioTextView.isScrollEnabled = true
        bioTextView.layer.cornerRadius = 8
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(bioTextView)
    }
    
    func setupBioLabel() {
        bioLabel = UILabel()
        bioLabel.text = "Bio"
        bioLabel.font = UIFont.systemFont(ofSize: 8, weight: .regular)
        bioLabel.textColor = .gray
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(bioLabel)
    }
    
    func setupCusineTableView() {
        cuisineTableView = UITableView()
        cuisineTableView.isHidden = true
        cuisineTableView.allowsMultipleSelection = true
        cuisineTableView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(cuisineTableView)
    }
    
    func setupCuisineTextField() {
        cuisineTextField = UITextField()
        cuisineTextField.borderStyle = .roundedRect
        cuisineTextField.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(cuisineTextField)
    }
    
    func setupCuisinePreferenceLabel() {
        cuisinePreferenceLabel = UILabel()
        cuisinePreferenceLabel.text = "Cuisine Preference"
        cuisinePreferenceLabel.font = UIFont.systemFont(ofSize: 8, weight: .regular)
        cuisinePreferenceLabel.textColor = .gray
        cuisinePreferenceLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(cuisinePreferenceLabel)
    }
    
    func setupLocationTextField() {
        locationTextField = UITextField()
        locationTextField.borderStyle = .roundedRect
        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(locationTextField)
    }
    
    func setupLocationLabel() {
        locationLabel = UILabel()
        locationLabel.text = "Location"
        locationLabel.font = UIFont.systemFont(ofSize: 8, weight: .regular)
        locationLabel.textColor = .gray
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(locationLabel)
    }
    
    func setupGenderSelectButton() {
        genderSelectButton = UIButton(type: .system)
        genderSelectButton.setTitle("Select Gender", for: .normal)
        genderSelectButton.setTitleColor(.black, for: .normal)
        genderSelectButton.backgroundColor = .white
        genderSelectButton.layer.cornerRadius = 5
        genderSelectButton.layer.borderWidth = 1
        genderSelectButton.layer.borderColor = UIColor.lightGray.cgColor
        genderSelectButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(genderSelectButton)
    }
    
    func setupGenderLabel() {
        genderLabel = UILabel()
        genderLabel.text = "Gender"
        genderLabel.font = UIFont.systemFont(ofSize: 8, weight: .regular)
        genderLabel.textColor = .gray
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(genderLabel)
    }
    
    func setupNameTextField() {
        nameTextField = UITextField()
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(nameTextField)
    }
    
    func setupNameLabel() {
        nameLabel = UILabel()
        nameLabel.text = "Name"
        nameLabel.font = UIFont.systemFont(ofSize: 8, weight: .regular)
        nameLabel.textColor = .gray
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(nameLabel)
    }
    
    func setupEditProfileImageButton() {
        editProfileImageButton = UIButton(type: .system)
        editProfileImageButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        //TODO: Set up the size of this button
        editProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(editProfileImageButton)
    }
    
    func setupProfileImage() {
        profileImage = UIImageView()
        profileImage.image = UIImage(systemName: "person.circle") // TODO: substitute to profile image later
        profileImage.contentMode = .scaleAspectFit
        profileImage.clipsToBounds = true
//        profileImage.layer.cornerRadius = 10
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(profileImage)
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(scrollView)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            // scroll view
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
             scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 18),
             scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
             scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            // profile image
            profileImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            profileImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            // edit profile image button
            editProfileImageButton.topAnchor.constraint(equalTo: profileImage.topAnchor),
            editProfileImageButton.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor),
            
            // name label
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            
            // name text field
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),
            
            // gender label
            genderLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            genderLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            // gender select button
            genderSelectButton.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 5),
            genderSelectButton.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            // location label
            locationLabel.topAnchor.constraint(equalTo: genderSelectButton.bottomAnchor, constant: 10),
            locationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            // location text field
            locationTextField.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5),
            locationTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            locationTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),
            
            // cuisine preference label
            cuisinePreferenceLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            cuisinePreferenceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            // cuisine text field
            cuisineTextField.topAnchor.constraint(equalTo: cuisinePreferenceLabel.bottomAnchor, constant: 5),
            cuisineTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            cuisineTextField.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),
            
            // cuisine table view
            cuisineTableView.topAnchor.constraint(equalTo: cuisineTextField.bottomAnchor), //TODO: need to confirm later
            cuisineTableView.centerXAnchor.constraint(equalTo: cuisineTextField.centerXAnchor), // TODO: need to confirm later
            
            // bio label
            bioLabel.topAnchor.constraint(equalTo: cuisineTextField.bottomAnchor, constant: 10),
            bioLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            // bio text view
            bioTextView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 5),
            bioTextView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            // save button
            saveButton.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 32),
            saveButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
        
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
