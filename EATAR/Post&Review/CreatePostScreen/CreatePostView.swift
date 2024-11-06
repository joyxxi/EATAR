//
//  CreatePostView.swift
//  EATAR
//
//  Created by kangweijia on 2024/11/1.
//

import UIKit


class CreatePostView: UIView {
    // MARK: - Properties
    let horizontalPadding: CGFloat = 16
    let buttonHeight: CGFloat = 44
    
    var titleLabel: UILabel!
    var restaurantField: UITextField!
    var cuisineButton: UIButton!
    var peopleButton: UIButton!
    var dateButton: UIButton!
    var locationField: UITextField!
    var noteField: UITextField!
    var postButton: UIButton!
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupTitleLabel()
        setupRestaurantField()
        setupCuisineButton()
        setupPeopleButton()
        setupDateButton()
        setupLocationField()
        setupNoteField()
        setupPostButton()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI Elements
    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Create a New Post"
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    
    func setupRestaurantField() {
        restaurantField = UITextField()
        restaurantField.placeholder = "Restaurant"
        restaurantField.borderStyle = .roundedRect
        restaurantField.textAlignment = .left
        restaurantField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(restaurantField)
    }
    
    func setupCuisineButton() {
        cuisineButton = UIButton(type: .system)
        cuisineButton.setTitle("Select Cuisine", for: .normal)
        cuisineButton.setTitleColor(.black, for: .normal)
        cuisineButton.contentHorizontalAlignment = .left
        cuisineButton.layer.borderWidth = 1
        cuisineButton.layer.borderColor = UIColor.systemGray4.cgColor
        cuisineButton.layer.cornerRadius = 5
        cuisineButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        cuisineButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cuisineButton)
    }
    
    func setupPeopleButton() {
        peopleButton = UIButton(type: .system)
        peopleButton.setTitle("Select Number of People", for: .normal)
        peopleButton.setTitleColor(.black, for: .normal)
        peopleButton.contentHorizontalAlignment = .left
        peopleButton.layer.borderWidth = 1
        peopleButton.layer.borderColor = UIColor.systemGray4.cgColor
        peopleButton.layer.cornerRadius = 5
        peopleButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        peopleButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(peopleButton)
    }
    
    func setupDateButton() {
        dateButton = UIButton(type: .system)
        dateButton.setTitle("Select Date and Time", for: .normal)
        dateButton.setTitleColor(.black, for: .normal)
        dateButton.contentHorizontalAlignment = .left
        dateButton.layer.borderWidth = 1
        dateButton.layer.borderColor = UIColor.systemGray4.cgColor
        dateButton.layer.cornerRadius = 5
        dateButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(dateButton)
    }
    
    func setupLocationField() {
        locationField = UITextField()
        locationField.placeholder = "Location"
        locationField.borderStyle = .roundedRect
        locationField.textAlignment = .left
        locationField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(locationField)
    }
    
    func setupNoteField() {
        noteField = UITextField()
        noteField.placeholder = "Note"
        noteField.borderStyle = .roundedRect
        noteField.textAlignment = .left
        noteField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(noteField)
    }
    
    func setupPostButton() {
        postButton = UIButton(type: .system)
        postButton.setTitle("Post", for: .normal)
        postButton.backgroundColor = .systemGray3
        postButton.setTitleColor(.white, for: .normal)
        postButton.layer.cornerRadius = 5
        postButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(postButton)
    }
    
    // MARK: - Constraints
    func initConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            
            restaurantField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            restaurantField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            restaurantField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            restaurantField.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            cuisineButton.topAnchor.constraint(equalTo: restaurantField.bottomAnchor, constant: 16),
            cuisineButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            cuisineButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            cuisineButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            peopleButton.topAnchor.constraint(equalTo: cuisineButton.bottomAnchor, constant: 16),
            peopleButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            peopleButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            peopleButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            dateButton.topAnchor.constraint(equalTo: peopleButton.bottomAnchor, constant: 16),
            dateButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            dateButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            dateButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            locationField.topAnchor.constraint(equalTo: dateButton.bottomAnchor, constant: 16),
            locationField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            locationField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            locationField.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            noteField.topAnchor.constraint(equalTo: locationField.bottomAnchor, constant: 16),
            noteField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            // Continuing CreatePostView constraints...
            noteField.topAnchor.constraint(equalTo: locationField.bottomAnchor, constant: 16),
            noteField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            noteField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            noteField.heightAnchor.constraint(equalToConstant: buttonHeight * 2),
                        
            postButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            postButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            postButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            postButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
}
