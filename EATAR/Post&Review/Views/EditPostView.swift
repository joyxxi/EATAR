//
//  Untitled.swift
//  EATAR
//
//  Created by kangweijia on 2024/11/26.
//

import UIKit

class EditPostView: UIView {
    
    var labelTitle: UILabel!
    var textFieldRestaurant: UITextField!
    var textFieldCuisine: UITextField!
    var textFieldPeople: UITextField!
    var textFieldTime: UITextField!
    var textFieldLocation: UITextField!
    var textFieldZipCode: UITextField!
    var textViewNote: UITextView!
    var buttonSaveChanges: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupTitle()
        setupRestaurantField()
        setupCuisineField()
        setupPeopleField()
        setupTimeField()
        setupLocationField()
        setupZipCodeField() 
        setupNoteField()
        setupSaveButton()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTitle() {
        labelTitle = UILabel()
        labelTitle.text = "Edit Post"
        labelTitle.font = .systemFont(ofSize: 24, weight: .bold)
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelTitle)
    }
    
    func createTextField(placeholder: String, withDropdown: Bool = false) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.backgroundColor = UIColor(red: 246/255, green: 241/255, blue: 236/255, alpha: 1.0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        if withDropdown {
            let dropdownButton = UIButton(type: .system)
            dropdownButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            dropdownButton.tintColor = .darkGray
            dropdownButton.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
            textField.rightView = dropdownButton
            textField.rightViewMode = .always
        }
        
        return textField
    }
    
    func setupRestaurantField() {
        textFieldRestaurant = createTextField(placeholder: "Restaurant")
        self.addSubview(textFieldRestaurant)
    }
    
    func setupCuisineField() {
        textFieldCuisine = createTextField(placeholder: "Cuisine", withDropdown: true)
        self.addSubview(textFieldCuisine)
    }
    
    func setupPeopleField() {
        textFieldPeople = createTextField(placeholder: "People", withDropdown: true)
        self.addSubview(textFieldPeople)
    }
    
    func setupTimeField() {
        textFieldTime = createTextField(placeholder: "Time")
        let calendarButton = UIButton(type: .system)
        calendarButton.setImage(UIImage(systemName: "calendar"), for: .normal)
        calendarButton.tintColor = .darkGray
        calendarButton.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        textFieldTime.rightView = calendarButton
        textFieldTime.rightViewMode = .always
        textFieldTime.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textFieldTime)
    }
    
    func setupLocationField() {
        textFieldLocation = createTextField(placeholder: "Location")
        self.addSubview(textFieldLocation)
    }
    
    func setupZipCodeField() {
        textFieldZipCode = createTextField(placeholder: "Zip Code")
        textFieldZipCode.keyboardType = .numberPad
        self.addSubview(textFieldZipCode)
    }
    
    func setupNoteField() {
        textViewNote = UITextView()
        textViewNote.layer.borderWidth = 1
        textViewNote.layer.borderColor = UIColor.systemGray4.cgColor
        textViewNote.layer.cornerRadius = 5
        textViewNote.font = .systemFont(ofSize: 16)
        textViewNote.backgroundColor = UIColor(red: 246/255, green: 241/255, blue: 236/255, alpha: 1.0)
        textViewNote.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textViewNote)
    }
    
    func setupSaveButton() {
        buttonSaveChanges = UIButton(type: .system)
        buttonSaveChanges.setTitle("Save Changes", for: .normal)
        buttonSaveChanges.backgroundColor = .systemBrown
        buttonSaveChanges.setTitleColor(.white, for: .normal)
        buttonSaveChanges.layer.cornerRadius = 8
        buttonSaveChanges.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonSaveChanges)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            labelTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            textFieldRestaurant.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 20),
            textFieldRestaurant.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textFieldRestaurant.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            textFieldRestaurant.heightAnchor.constraint(equalToConstant: 44),
            
            textFieldCuisine.topAnchor.constraint(equalTo: textFieldRestaurant.bottomAnchor, constant: 16),
            textFieldCuisine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textFieldCuisine.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            textFieldCuisine.heightAnchor.constraint(equalToConstant: 44),
            
            textFieldPeople.topAnchor.constraint(equalTo: textFieldCuisine.bottomAnchor, constant: 16),
            textFieldPeople.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textFieldPeople.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            textFieldPeople.heightAnchor.constraint(equalToConstant: 44),
            
            textFieldTime.topAnchor.constraint(equalTo: textFieldPeople.bottomAnchor, constant: 16),
            textFieldTime.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textFieldTime.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            textFieldTime.heightAnchor.constraint(equalToConstant: 44),
            
            textFieldLocation.topAnchor.constraint(equalTo: textFieldTime.bottomAnchor, constant: 16),
            textFieldLocation.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textFieldLocation.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            textFieldLocation.heightAnchor.constraint(equalToConstant: 44),
            
            textFieldZipCode.topAnchor.constraint(equalTo: textFieldLocation.bottomAnchor, constant: 16),
            textFieldZipCode.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textFieldZipCode.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            textFieldZipCode.heightAnchor.constraint(equalToConstant: 44),
            
            textViewNote.topAnchor.constraint(equalTo: textFieldZipCode.bottomAnchor, constant: 16),
            textViewNote.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textViewNote.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            textViewNote.heightAnchor.constraint(equalToConstant: 100),
            
            buttonSaveChanges.topAnchor.constraint(equalTo: textViewNote.bottomAnchor, constant: 24),
            buttonSaveChanges.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            buttonSaveChanges.widthAnchor.constraint(equalToConstant: 200),
            buttonSaveChanges.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
