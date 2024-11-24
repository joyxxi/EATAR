//
//  LandingPageView.swift
//  EATAR
//
//  Created by Yogi Yu on 11/6/24.
//

import UIKit

class LandingPageView: UIView {
    
    var backgroundImageView: UIImageView!
    var titleLabel: UILabel!
    var subtitleLabel: UILabel!
    var loginButton: UIButton!
    var signupButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupBackgroundImage()
        setupTitleLabel()
        setupSubtitleLabel()
        setupLogInButton()
        setupSignUpButton()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBackgroundImage() {
        backgroundImageView = UIImageView()
        backgroundImageView.image = UIImage(named: "bg_pic")
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

    func setupTitleLabel(){
        titleLabel = UILabel()
        titleLabel.text = "Eatar"
        titleLabel.textColor = .brown
        titleLabel.font = UIFont.systemFont(ofSize: 57, weight: .bold)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    
    func setupSubtitleLabel(){
        subtitleLabel = UILabel()
        subtitleLabel.text = "Find Your Dining Buddy Today!"
        subtitleLabel.textColor = .brown
        subtitleLabel.font = UIFont.systemFont(ofSize: 16)
        subtitleLabel.textAlignment = .left
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(subtitleLabel)
    }
    
    func setupLogInButton(){
        loginButton = UIButton(type: .system)
        loginButton.setTitle("Log In", for: .normal)
        loginButton.backgroundColor = .systemBrown
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 8
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(loginButton)
    }
    
    func setupSignUpButton(){
        signupButton = UIButton(type: .system)
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.backgroundColor = .systemBrown
        signupButton.setTitleColor(.white, for: .normal)
        signupButton.layer.cornerRadius = 8
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(signupButton)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28),
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 220),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            loginButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 130),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            signupButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            signupButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            signupButton.widthAnchor.constraint(equalToConstant: 200),
            signupButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
