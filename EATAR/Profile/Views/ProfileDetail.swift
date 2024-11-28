//
//  ProfileDetail.swift
//  EATAR
//
//

import UIKit

class ProfileDetail: UIView {
    var scrollView: UIScrollView!
    var profileImage: UIImageView!
    var nameLabel: UILabel!
    var genderLabel: UILabel!
    var locationLabel: UILabel!
    var cuisinePreferenceLabel: UILabel!
    var favoriteRestaurantLabel: UILabel!
    var bioLabel: UILabel!
    var editButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupScrollView()
        setupProfileImage()
        setupNameLabel()
        setupGenderLabel()
        setupLocationLabel()
        setupCuisinePreferenceLabel()
        setupFavoriteRestaurantLabel()
        setupBioLabel()
        setupEditButton()
        
        
        initConstraints()
        
        
    }
    func setupEditButton() {
        editButton = UIButton(type: .system)
        editButton.setTitle("Edit Profile", for: .normal)
        editButton.backgroundColor = .systemBrown
        editButton.setTitleColor(.white, for: .normal)
        editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        editButton.layer.cornerRadius = 25
        editButton.clipsToBounds = true
        editButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(editButton)
        
        // add rounded corners and border
//        editButton.layer.cornerRadius = 10
//        editButton.layer.borderWidth = 2
//        editButton.layer.borderColor = UIColor.black.cgColor
        
        // add shadow
//        editButton.layer.shadowColor = UIColor.black.cgColor
//        editButton.layer.shadowOffset = CGSize(width: 3, height: 3)
//        editButton.layer.shadowOpacity = 0.8
//        editButton.layer.shadowRadius = 4
        

    }
    
    
    
    func setupBioLabel() {
        bioLabel = UILabel()
        bioLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.numberOfLines = 0
        bioLabel.lineBreakMode = .byWordWrapping
        bioLabel.text = "Bio: "
        scrollView.addSubview(bioLabel)
    }
    
    func setupFavoriteRestaurantLabel() {
        favoriteRestaurantLabel = UILabel()
        favoriteRestaurantLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        favoriteRestaurantLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteRestaurantLabel.numberOfLines = 0
        favoriteRestaurantLabel.lineBreakMode = .byWordWrapping
        favoriteRestaurantLabel.text = "Favorite Restaurant: "
        scrollView.addSubview(favoriteRestaurantLabel)
    }
    
    func setupCuisinePreferenceLabel() {
        cuisinePreferenceLabel = UILabel()
        cuisinePreferenceLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        cuisinePreferenceLabel.translatesAutoresizingMaskIntoConstraints = false
        cuisinePreferenceLabel.numberOfLines = 0
        cuisinePreferenceLabel.lineBreakMode = .byWordWrapping
        cuisinePreferenceLabel.text = "Cuisine Preferences: "
        scrollView.addSubview(cuisinePreferenceLabel)
    }
    
    func setupLocationLabel() {
        locationLabel = UILabel()
        locationLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.numberOfLines = 0
        locationLabel.lineBreakMode = .byWordWrapping
        locationLabel.text = "Location: "
        scrollView.addSubview(locationLabel)
    }
    
    func setupGenderLabel() {
        genderLabel = UILabel()
        genderLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderLabel.text = "Gender: "
        scrollView.addSubview(genderLabel)
    }
    
    func setupNameLabel() {
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.text = "Name: "
        scrollView.addSubview(nameLabel)
    }
    
    
    func setupProfileImage() {
        profileImage = UIImageView()
        profileImage.image = UIImage(systemName: "person.circle")
        profileImage.contentMode = .scaleAspectFit
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = 50
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
            profileImage.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            profileImage.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 150),
            profileImage.heightAnchor.constraint(equalToConstant: 150),
            
            // name label
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 32),
            nameLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            
            // gender label
            genderLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            genderLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            // location label
            locationLabel.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 16),
            locationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            // cuisine preference label
            cuisinePreferenceLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 16),
            cuisinePreferenceLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            // favorite restaurant label
            favoriteRestaurantLabel.topAnchor.constraint(equalTo: cuisinePreferenceLabel.bottomAnchor, constant: 16),
            favoriteRestaurantLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            // bio label
            bioLabel.topAnchor.constraint(equalTo: favoriteRestaurantLabel.bottomAnchor, constant: 16),
            bioLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            // edit button
            editButton.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 64),
            editButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            editButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -32)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
