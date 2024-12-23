//
//  SignupView.swift
//  EATAR
//
//  Created by Yogi Yu on 11/6/24.
//

import UIKit

class SignupView: UIView {

    var labelSignUp: UILabel!
    var labelSentence: UILabel!
    var textfieldName: UITextField!
    var textfieldEmail: UITextField!
    var textfieldPassword: UITextField!
    var textfieldConfirmPassword: UITextField!
    var buttonSignUp: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupLabelSignUp()
        setupLabelSentence()
        setupTextFieldName()
        setupTextFieldEmail()
        setupTextFieldPassword()
        setupTextFieldConfirmPassword()
        setupButtonSignUp()
        
        initConstraints()
    }
    
    func setupLabelSignUp(){
        labelSignUp = UILabel()
        labelSignUp.text = "Sign Up"
        labelSignUp.textColor = .brown
        labelSignUp.font = UIFont.boldSystemFont(ofSize: 30)
        labelSignUp.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelSignUp)
    }
    
    func setupLabelSentence(){
        labelSentence = UILabel()
        labelSentence.text = "Create your account;)"
        labelSentence.textColor = .systemBrown
        labelSentence.font = UIFont.systemFont(ofSize: 15)
        labelSentence.textAlignment = .center
        labelSentence.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelSentence)
    }
    
    func createCustomTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.backgroundColor = UIColor(red: 246/255, green: 241/255, blue: 236/255, alpha: 1.0)
        textField.layer.cornerRadius = 15
        textField.clipsToBounds = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // Add padding with fixed height
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10)) // Fixed height
        textField.leftView = paddingView
        textField.leftViewMode = .always

        return textField
    }
    
    func setupTextFieldName(){
        textfieldName = createCustomTextField(placeholder: "  Username")
        textfieldName.autocapitalizationType = .none
        self.addSubview(textfieldName)
    }
    
    func setupTextFieldEmail(){
        textfieldEmail = createCustomTextField(placeholder: "  Email")
        textfieldEmail.autocapitalizationType = .none
        textfieldEmail.keyboardType = .emailAddress
        self.addSubview(textfieldEmail)
    }
    
    func setupTextFieldPassword(){
        textfieldPassword = createCustomTextField(placeholder: "  Password")
        textfieldPassword.isSecureTextEntry = true
        self.addSubview(textfieldPassword)
    }
    
    func setupTextFieldConfirmPassword(){
        textfieldConfirmPassword = createCustomTextField(placeholder: "  Confirm Password")
        textfieldConfirmPassword.isSecureTextEntry = true
        self.addSubview(textfieldConfirmPassword)
    }
    
    func setupButtonSignUp() {
        buttonSignUp = UIButton(type: .system)
        buttonSignUp.setTitle("Sign up", for: .normal)
        buttonSignUp.backgroundColor = .systemBrown
        buttonSignUp.setTitleColor(.white, for: .normal)
        buttonSignUp.layer.cornerRadius = 25
        buttonSignUp.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonSignUp)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            labelSignUp.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            labelSignUp.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            labelSentence.topAnchor.constraint(equalTo: labelSignUp.bottomAnchor, constant: 5),
            labelSentence.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            textfieldName.topAnchor.constraint(equalTo: labelSentence.bottomAnchor, constant: 80),
            textfieldName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textfieldName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            textfieldName.heightAnchor.constraint(equalToConstant: 50),
            
            textfieldEmail.topAnchor.constraint(equalTo: textfieldName.bottomAnchor, constant: 10),
            textfieldEmail.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textfieldEmail.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            textfieldEmail.heightAnchor.constraint(equalToConstant: 50),
            
            textfieldPassword.topAnchor.constraint(equalTo: textfieldEmail.bottomAnchor, constant: 10),
            textfieldPassword.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textfieldPassword.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            textfieldPassword.heightAnchor.constraint(equalToConstant: 50),
            
            textfieldConfirmPassword.topAnchor.constraint(equalTo: textfieldPassword.bottomAnchor, constant: 10),
            textfieldConfirmPassword.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            textfieldConfirmPassword.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            textfieldConfirmPassword.heightAnchor.constraint(equalToConstant: 50),
            
            buttonSignUp.topAnchor.constraint(equalTo: textfieldConfirmPassword.bottomAnchor, constant: 80),
            buttonSignUp.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 120),
            buttonSignUp.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -120),
            buttonSignUp.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
