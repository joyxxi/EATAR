//
//  SignInView.swift
//  EATAR
//
//  Created by Yogi Yu on 11/6/24.
//

import UIKit

class SignInView: UIView {
    
    var backgroundImageView: UIImageView!
    var labelTitle: UILabel!
    var laberCreateAccount: UILabel!
    var textFieldUsername: UITextField!
    var textFieldPassword: UITextField!
    var labelForgotPassword: UILabel!
    var buttonSignIn: UIButton!
    var labelSentence: UILabel!
    var buttonSignUp: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupBackgroundImage()
        setupLabelTitle()
        setupLabelCreateAccount()
        setupTextFieldUserName()
        setupTextFieldPassword()
        setupButtonSignIn()
        setupLabelSentence()
        setupButtonSignUp()
        setupLabelForgotPassword()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBackgroundImage() {
        backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "pg_pic1")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backgroundImageView)
        
        self.sendSubviewToBack(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func setupLabelTitle() {
        labelTitle = UILabel()
        labelTitle.text = "Eatar"
        labelTitle.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        labelTitle.textColor = .brown
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelTitle.textAlignment = .center
        self.addSubview(labelTitle)
    }
    
    func setupLabelCreateAccount(){
        laberCreateAccount = UILabel()
        laberCreateAccount.text = "Welcome Back ;)"
        laberCreateAccount.textColor = .systemBrown
        laberCreateAccount.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        laberCreateAccount.textAlignment = .center
        laberCreateAccount.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(laberCreateAccount)
    }
    
    func setupTextFieldUserName(){
        textFieldUsername = UITextField()
        textFieldUsername.autocapitalizationType = .none
        textFieldUsername.placeholder = " Username"
        textFieldUsername.backgroundColor = UIColor(red: 246/255, green: 241/255, blue: 236/255, alpha: 1.0)
        textFieldUsername.layer.cornerRadius = 15
        textFieldUsername.clipsToBounds = true
        textFieldUsername.leftViewMode = .always
        textFieldUsername.translatesAutoresizingMaskIntoConstraints = false
        
        let personIcon = UIImageView(image: UIImage(systemName: "person"))
        personIcon.tintColor = .brown
        textFieldUsername.leftView = personIcon
        textFieldUsername.leftView?.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        textFieldUsername.leftViewMode = .always
        self.addSubview(textFieldUsername)
    }
    
    func setupTextFieldPassword(){
        textFieldPassword = UITextField()
        textFieldPassword.placeholder = "  Password"
        textFieldPassword.backgroundColor = UIColor(red: 246/255, green: 241/255, blue: 236/255, alpha: 1.0)
        textFieldPassword.layer.cornerRadius = 15
        textFieldPassword.clipsToBounds = true
        textFieldPassword.isSecureTextEntry = true
        textFieldPassword.leftViewMode = .always
        textFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        
        let passwordIcon = UIImageView(image: UIImage(systemName: "lock"))
        passwordIcon.tintColor = .brown
        textFieldPassword.leftView = passwordIcon
        textFieldPassword.leftView?.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
        textFieldPassword.leftViewMode = .always
        self.addSubview(textFieldPassword)
    }
    
    func setupLabelForgotPassword(){
        labelForgotPassword = UILabel()
        labelForgotPassword.text = "Forgot Password?"
        labelForgotPassword.font = UIFont.systemFont(ofSize: 12)
        labelForgotPassword.textColor = .gray
        labelForgotPassword.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelForgotPassword)
    }
    
    func setupButtonSignIn(){
        buttonSignIn = UIButton(type: .system)
        buttonSignIn.setTitle("Log In", for: .normal)
        buttonSignIn.backgroundColor = .systemBrown
        buttonSignIn.setTitleColor(.white, for: .normal)
        buttonSignIn.layer.cornerRadius = 10
        buttonSignIn.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonSignIn)
    }
    
    func setupLabelSentence(){
        labelSentence = UILabel()
        labelSentence.text = "Don't Have an Account?"
        labelSentence.textColor = .gray
        labelSentence.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(labelSentence)
    }
    
    func setupButtonSignUp(){
        buttonSignUp = UIButton(type: .system)
        buttonSignUp.setTitle("Sign Up", for: .normal)
        buttonSignUp.setTitleColor(.red, for: .normal)
        buttonSignUp.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonSignUp)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            labelTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
            labelTitle.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            laberCreateAccount.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 20),
            laberCreateAccount.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            textFieldUsername.topAnchor.constraint(equalTo: laberCreateAccount.bottomAnchor, constant: 50),
            textFieldUsername.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            textFieldUsername.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            textFieldUsername.heightAnchor.constraint(equalToConstant: 50),
            
            textFieldPassword.topAnchor.constraint(equalTo: textFieldUsername.bottomAnchor, constant: 20),
            textFieldPassword.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
            textFieldPassword.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            textFieldPassword.heightAnchor.constraint(equalToConstant: 50),
            
            labelForgotPassword.topAnchor.constraint(equalTo: textFieldPassword.bottomAnchor, constant: 6),
            labelForgotPassword.trailingAnchor.constraint(equalTo: textFieldPassword.trailingAnchor, constant: -10),
            
            buttonSignIn.topAnchor.constraint(equalTo: labelForgotPassword.bottomAnchor, constant: 40),
            buttonSignIn.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 130),
            buttonSignIn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -130),
            buttonSignIn.heightAnchor.constraint(equalToConstant: 50),
            
            labelSentence.topAnchor.constraint(equalTo: buttonSignIn.bottomAnchor, constant: 20),
            labelSentence.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            buttonSignUp.topAnchor.constraint(equalTo: labelSentence.bottomAnchor, constant: 5),
            buttonSignUp.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
}

