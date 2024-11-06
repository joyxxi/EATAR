//
//  PostDetailsView.swift
//  EATAR
//
//  Created by kangweijia on 2024/11/1.
//

import UIKit

class PostDetailsView: UIView {
    // MARK: - Properties
    let horizontalPadding: CGFloat = 16
    let buttonHeight: CGFloat = 44
    
    var titleLabel: UILabel!
    var detailsLabel: UILabel!
    var peopleJoinedLabel: UILabel!
    var peopleStackView: UIStackView!
    var joinButton: UIButton!
    var leaveButton: UIButton!
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupTitleLabel()
        setupDetailsLabel()
        setupPeopleJoinedLabel()
        setupPeopleStackView()
        setupJoinButton()
        setupLeaveButton()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI Elements
    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "Join Me at Shang Cafe"
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    
    func setupDetailsLabel() {
        detailsLabel = UILabel()
        detailsLabel.numberOfLines = 0
        detailsLabel.text = """
            Restaurant: Shang Cafe
            Rating: 4.7/5.0
            Cuisine: Chinese
            People: 2/4
            Time: 10/13/24 Lunch
            Location: XX St, San Jose, CA
            """
        detailsLabel.font = .systemFont(ofSize: 16)
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(detailsLabel)
    }
    
    func setupPeopleJoinedLabel() {
        peopleJoinedLabel = UILabel()
        peopleJoinedLabel.text = "People Joined:"
        peopleJoinedLabel.font = .systemFont(ofSize: 16)
        peopleJoinedLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(peopleJoinedLabel)
    }
    
    func setupPeopleStackView() {
        peopleStackView = UIStackView()
        peopleStackView.axis = .horizontal
        peopleStackView.spacing = 10
        peopleStackView.distribution = .fillEqually
        peopleStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(peopleStackView)
        
        // Add person icons
        for i in 0..<4 {
            let personView = UIImageView()
            personView.image = UIImage(systemName: "person.circle.fill")
            personView.tintColor = i < 2 ? .systemGray3 : .systemGray5
            personView.contentMode = .scaleAspectFit
            peopleStackView.addArrangedSubview(personView)
        }
    }
    
    func setupJoinButton() {
        joinButton = UIButton(type: .system)
        joinButton.setTitle("Join", for: .normal)
        joinButton.backgroundColor = .systemGray3
        joinButton.setTitleColor(.white, for: .normal)
        joinButton.layer.cornerRadius = 5
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(joinButton)
    }
    
    func setupLeaveButton() {
        leaveButton = UIButton(type: .system)
        leaveButton.setTitle("Leave", for: .normal)
        leaveButton.backgroundColor = .systemGray3
        leaveButton.setTitleColor(.white, for: .normal)
        leaveButton.layer.cornerRadius = 5
        leaveButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(leaveButton)
    }
    
    // MARK: - Constraints
    func initConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            
            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            detailsLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            detailsLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            
            peopleJoinedLabel.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 24),
            peopleJoinedLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            
            peopleStackView.topAnchor.constraint(equalTo: peopleJoinedLabel.bottomAnchor, constant: 12),
            peopleStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            peopleStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            peopleStackView.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            joinButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            joinButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            joinButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
            joinButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            leaveButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            leaveButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            leaveButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4),
            leaveButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
}
