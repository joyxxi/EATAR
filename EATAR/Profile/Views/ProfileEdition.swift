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
    var favoriteRestaurantLabel: UILabel!
    var favoriteResetaurantTextField: UITextField!
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
        setupFavoriteRestaurantLabel()
        setupFavoriteRestaurantTextField()
        setupBioLabel()
        setupBioTextView()
        setupSaveButton()
    
        
        initConstraints()
    }
    
    func loadRemoteImage(from url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.profileImage.image = image
                    }
                }
            }
        }
    }
    
    func setupSaveButton() {
        saveButton = UIButton(type: .system)
        saveButton.backgroundColor = .systemBrown
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.setTitle("Save", for: .normal)
        saveButton.layer.cornerRadius = 25
        saveButton.clipsToBounds = true
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        saveButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(saveButton)
    }
    
    func setupBioTextView() {
        bioTextView = UITextView()
        bioTextView.isEditable = true
        bioTextView.isScrollEnabled = true
        bioTextView.layer.cornerRadius = 8
        bioTextView.backgroundColor = UIColor(red: 246/255, green: 241/255, blue: 236/255, alpha: 1.0)
        bioTextView.textColor = .systemBrown
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(bioTextView)
    }
    
    func setupBioLabel() {
        bioLabel = UILabel()
        bioLabel.text = "Bio"
        bioLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
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
    
    func setupFavoriteRestaurantTextField() {
        favoriteResetaurantTextField = UITextField()
        favoriteResetaurantTextField.borderStyle = .roundedRect
        favoriteResetaurantTextField.translatesAutoresizingMaskIntoConstraints = false
        favoriteResetaurantTextField.backgroundColor = UIColor(red: 246/255, green: 241/255, blue: 236/255, alpha: 1.0)
        favoriteResetaurantTextField.textColor = .systemBrown
        scrollView.addSubview(favoriteResetaurantTextField)
    }
    
    func setupFavoriteRestaurantLabel() {
        favoriteRestaurantLabel = UILabel()
        favoriteRestaurantLabel.text = "Favorite Restaurant"
        favoriteRestaurantLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        favoriteRestaurantLabel.textColor = .gray
        favoriteRestaurantLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(favoriteRestaurantLabel)
    }
    
    func setupCuisineTextField() {
        cuisineTextField = UITextField()
        cuisineTextField.borderStyle = .roundedRect
        cuisineTextField.translatesAutoresizingMaskIntoConstraints = false
//        cuisineTextField.placeholder = "This is the cuisine"
//        cuisineTextField.borderStyle = .roundedRect
        cuisineTextField.backgroundColor = UIColor(red: 246/255, green: 241/255, blue: 236/255, alpha: 1.0)
        cuisineTextField.textColor = .systemBrown
        scrollView.addSubview(cuisineTextField)
    }
    
    func setupCuisinePreferenceLabel() {
        cuisinePreferenceLabel = UILabel()
        cuisinePreferenceLabel.text = "Cuisine Preference"
        cuisinePreferenceLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        cuisinePreferenceLabel.textColor = .gray
        cuisinePreferenceLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(cuisinePreferenceLabel)
    }
    
    func setupLocationTextField() {
        locationTextField = UITextField()
        locationTextField.borderStyle = .roundedRect
        locationTextField.translatesAutoresizingMaskIntoConstraints = false
        locationTextField.backgroundColor = UIColor(red: 246/255, green: 241/255, blue: 236/255, alpha: 1.0)
        locationTextField.textColor = .systemBrown
        locationTextField.placeholder = "Type in your zipcode..."
        scrollView.addSubview(locationTextField)
    }
    
    func setupLocationLabel() {
        locationLabel = UILabel()
        locationLabel.text = "Location"
        locationLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        locationLabel.textColor = .gray
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(locationLabel)
    }
    
    func setupGenderSelectButton() {
        genderSelectButton = UIButton(type: .system)
        genderSelectButton.setTitle("Select Gender", for: .normal)
        genderSelectButton.setTitleColor(.systemBrown, for: .normal)
        genderSelectButton.backgroundColor = .white
        genderSelectButton.layer.cornerRadius = 5
        genderSelectButton.showsMenuAsPrimaryAction = true
//        genderSelectButton.layer.borderWidth = 1
//        genderSelectButton.layer.borderColor = UIColor.lightGray.cgColor
        genderSelectButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(genderSelectButton)
    }
    
    func setupGenderLabel() {
        genderLabel = UILabel()
        genderLabel.text = "Gender"
        genderLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        genderLabel.textColor = .gray
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(genderLabel)
    }
    
    func setupNameTextField() {
        nameTextField = UITextField()
        nameTextField.borderStyle = .roundedRect
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.backgroundColor = UIColor(red: 246/255, green: 241/255, blue: 236/255, alpha: 1.0)
        nameTextField.textColor = .systemBrown
        scrollView.addSubview(nameTextField)
    }
    
    func setupNameLabel() {
        nameLabel = UILabel()
        nameLabel.text = "Username"
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        nameLabel.textColor = .gray
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(nameLabel)
    }
    
    func setupEditProfileImageButton() {
        editProfileImageButton = UIButton(type: .system)
        editProfileImageButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editProfileImageButton.tintColor = .systemBrown
        editProfileImageButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(editProfileImageButton)
    }
    
    func setupProfileImage() {
        profileImage = UIImageView()
        profileImage.image = UIImage(systemName: "person.circle")
        profileImage.tintColor = .systemBrown
        profileImage.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 75
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
             scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
             scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
             scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            // profile image
            profileImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            profileImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 150),
            profileImage.heightAnchor.constraint(equalToConstant: 150),
            
            // edit profile image button
            editProfileImageButton.topAnchor.constraint(equalTo: profileImage.topAnchor),
            editProfileImageButton.trailingAnchor.constraint(equalTo: profileImage.trailingAnchor),
            editProfileImageButton.widthAnchor.constraint(equalToConstant: 24),
            editProfileImageButton.heightAnchor.constraint(equalToConstant: 24),
            
            // name label
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            
            // name text field
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            nameTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            nameTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            
            // gender label
            genderLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            genderLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            // gender select button
            genderSelectButton.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 5),
            genderSelectButton.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 8),
            
            // location label
            locationLabel.topAnchor.constraint(equalTo: genderSelectButton.bottomAnchor, constant: 10),
            locationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            // location text field
            locationTextField.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 5),
            locationTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            locationTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            
            // cuisine preference label
            cuisinePreferenceLabel.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 10),
            cuisinePreferenceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            // cuisine text field
            cuisineTextField.topAnchor.constraint(equalTo: cuisinePreferenceLabel.bottomAnchor, constant: 5),
            cuisineTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            cuisineTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            
            // cuisine table view
            cuisineTableView.topAnchor.constraint(equalTo: cuisineTextField.bottomAnchor), //TODO: need to confirm later
            cuisineTableView.centerXAnchor.constraint(equalTo: cuisineTextField.centerXAnchor), // TODO: need to confirm later
            
            // favorite restuarant label
            favoriteRestaurantLabel.topAnchor.constraint(equalTo: cuisineTextField.bottomAnchor, constant: 10),
            favoriteRestaurantLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            // favorite restuarant text field
            favoriteResetaurantTextField.topAnchor.constraint(equalTo: favoriteRestaurantLabel.bottomAnchor, constant: 5),
            favoriteResetaurantTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            favoriteResetaurantTextField.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            
            
            // bio label
            bioLabel.topAnchor.constraint(equalTo: favoriteResetaurantTextField.bottomAnchor, constant: 10),
            bioLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            // bio text view
            bioTextView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 5),
            bioTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            bioTextView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            bioTextView.heightAnchor.constraint(equalToConstant: 120),
            
            // save button
            saveButton.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 32),
            saveButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            saveButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
        
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
