//
//  Untitled.swift
//  EATAR
//
//  Created by kangweijia on 2024/11/26.
//

import UIKit

class JoinPostView: UIView {
    
    var backButton: UIButton!
    var titleLabel: UILabel!
    var restaurantInfoLabel: UILabel!
    var ratingLabel: UILabel!
    var cuisineLabel: UILabel!
    var peopleLabel: UILabel!
    var timeLabel: UILabel!
    var locationLabel: UILabel!
    var zipCodeLabel: UILabel!
    var peopleJoinedLabel: UILabel!
    var joinedPeopleStackView: UIStackView!
    var buttonStackView: UIStackView!
    var joinButton: UIButton!
    var leaveButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupBackButton()
        setupTitleLabel()
        setupRestaurantInfo()
        setupDetailsLabels()
        setupPeopleJoined()
        setupButtons()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupBackButton() {
        backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(backButton)
    }
    
    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Join Me at Shang Cafe"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    
    func setupRestaurantInfo() {
        restaurantInfoLabel = UILabel()
        restaurantInfoLabel.text = "Restaurant: Shang Cafe"
        restaurantInfoLabel.font = .systemFont(ofSize: 16)
        restaurantInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(restaurantInfoLabel)
        
        ratingLabel = UILabel()
        ratingLabel.text = "Rating: 4.7/5.0"
        ratingLabel.font = .systemFont(ofSize: 16)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(ratingLabel)
    }
    
    func setupDetailsLabels() {
        cuisineLabel = UILabel()
        cuisineLabel.text = "Cuisine: Chinese"
        cuisineLabel.font = .systemFont(ofSize: 16)
        cuisineLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(cuisineLabel)
        
        peopleLabel = UILabel()
        peopleLabel.text = "People: 2/4"
        peopleLabel.font = .systemFont(ofSize: 16)
        peopleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(peopleLabel)
        
        timeLabel = UILabel()
        timeLabel.text = "Time: 10/13/24 Lunch"
        timeLabel.font = .systemFont(ofSize: 16)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(timeLabel)
        
        locationLabel = UILabel()
        locationLabel.text = "Location: xx St, San Jose, CA"
        locationLabel.font = .systemFont(ofSize: 16)
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(locationLabel)
    }
    
    func setupPeopleJoined() {
        peopleJoinedLabel = UILabel()
        peopleJoinedLabel.text = "People Joined:"
        peopleJoinedLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        peopleJoinedLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(peopleJoinedLabel)
        
        joinedPeopleStackView = UIStackView()
        joinedPeopleStackView.axis = .horizontal
        joinedPeopleStackView.spacing = 10
        joinedPeopleStackView.distribution = .fillEqually
        joinedPeopleStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add avatar circles
        for i in 0..<4 {
            let avatarView = UIView()
            avatarView.backgroundColor = i < 2 ? .systemGray3 : .systemGray5
            avatarView.layer.cornerRadius = 20
            avatarView.translatesAutoresizingMaskIntoConstraints = false
            avatarView.heightAnchor.constraint(equalToConstant: 40).isActive = true
            avatarView.widthAnchor.constraint(equalToConstant: 40).isActive = true
            joinedPeopleStackView.addArrangedSubview(avatarView)
        }
        
        self.addSubview(joinedPeopleStackView)
    }
    
    func setupButtons() {
        buttonStackView = UIStackView()
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 20
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        joinButton = UIButton(type: .system)
        joinButton.setTitle("Join", for: .normal)
        joinButton.backgroundColor = .systemBrown
        joinButton.setTitleColor(.white, for: .normal)
        joinButton.layer.cornerRadius = 8
        
        leaveButton = UIButton(type: .system)
        leaveButton.setTitle("Leave", for: .normal)
        leaveButton.backgroundColor = .systemBrown
        leaveButton.setTitleColor(.white, for: .normal)
        leaveButton.layer.cornerRadius = 8
        
        buttonStackView.addArrangedSubview(joinButton)
        buttonStackView.addArrangedSubview(leaveButton)
        self.addSubview(buttonStackView)
    }
    
    func setupZipCodeLabel() {
        zipCodeLabel = UILabel()
        zipCodeLabel.font = .systemFont(ofSize: 16)
        zipCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(zipCodeLabel)
    }

    
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            
            restaurantInfoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            restaurantInfoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            ratingLabel.topAnchor.constraint(equalTo: restaurantInfoLabel.bottomAnchor, constant: 8),
            ratingLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            cuisineLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 8),
            cuisineLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            peopleLabel.topAnchor.constraint(equalTo: cuisineLabel.bottomAnchor, constant: 8),
            peopleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            timeLabel.topAnchor.constraint(equalTo: peopleLabel.bottomAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            locationLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            locationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            zipCodeLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            zipCodeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            peopleJoinedLabel.topAnchor.constraint(equalTo: zipCodeLabel.bottomAnchor, constant: 30),
            peopleJoinedLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            joinedPeopleStackView.topAnchor.constraint(equalTo: peopleJoinedLabel.bottomAnchor, constant: 10),
            joinedPeopleStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            joinedPeopleStackView.widthAnchor.constraint(equalToConstant: 190),
            joinedPeopleStackView.heightAnchor.constraint(equalToConstant: 40),
            
            buttonStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            buttonStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
