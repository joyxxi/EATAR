//
//  Untitled.swift
//  EATAR
//
//  Created by kangweijia on 2024/11/26.
//

import UIKit
import FirebaseFirestore

class JoinPostView: UIView {
    
//    var backButton: UIButton!
    
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
    var noteLabel: UILabel!
    var buttonStackView: UIStackView!
    var joinButton: UIButton!
    var leaveButton: UIButton!
    var participantsContainerView: UIView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
//        setupBackButton()
        setupTitleLabel()
        setupRestaurantInfo()
        setupDetailsLabels()
        setupPeopleJoined()
        setupNoteLabel()
        setupZipCodeLabel()
        setupButtons()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func setupBackButton() {
//        backButton = UIButton(type: .system)
//        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
//        backButton.tintColor = .black
//        backButton.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(backButton)
//    }
    
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
            
            // Create container view for participants
            participantsContainerView = UIView()
            participantsContainerView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(participantsContainerView)
    }
    
    // In JoinPostView.swift
    func updateParticipantCircles(maxPeople: Int, participants: [String], currentUserEmail: String?) {
        participantsContainerView.subviews.forEach { $0.removeFromSuperview() }
        
        let circlesPerRow = 5
        let circleSize: CGFloat = 40
        let horizontalSpacing: CGFloat = 10
        let verticalSpacing: CGFloat = 10
        
        var currentRow = 0
        var currentColumn = 0
        
        for i in 0..<maxPeople {
            // Create container view for the circle
            let avatarContainer = UIView()
            avatarContainer.translatesAutoresizingMaskIntoConstraints = false
            avatarContainer.layer.cornerRadius = circleSize / 2
            avatarContainer.clipsToBounds = true
            
            // Create imageView for profile picture
            let avatarImageView = UIImageView()
            avatarImageView.contentMode = .scaleAspectFill
            avatarImageView.translatesAutoresizingMaskIntoConstraints = false
            avatarContainer.addSubview(avatarImageView)
            
            if i < participants.count {
                // Existing participant
                fetchUserProfile(email: participants[i]) { profileImageUrl in
                    if let imageUrl = profileImageUrl {
                        self.loadImage(from: imageUrl, into: avatarImageView)
                    }
                }
                avatarContainer.backgroundColor = .systemGray3
            } else if i == participants.count && currentUserEmail != nil {
                // Next empty spot (preview for current user)
                fetchUserProfile(email: currentUserEmail!) { profileImageUrl in
                    if let imageUrl = profileImageUrl {
                        self.loadImage(from: imageUrl, into: avatarImageView)
                        avatarImageView.alpha = 0.5 // Semi-transparent to indicate preview
                    }
                }
                avatarContainer.backgroundColor = .systemGray5
            } else {
                // Empty spot
                avatarContainer.backgroundColor = .systemGray5
            }
            
            participantsContainerView.addSubview(avatarContainer)
            
            // Layout constraints for avatar image
            NSLayoutConstraint.activate([
                avatarImageView.topAnchor.constraint(equalTo: avatarContainer.topAnchor),
                avatarImageView.leadingAnchor.constraint(equalTo: avatarContainer.leadingAnchor),
                avatarImageView.trailingAnchor.constraint(equalTo: avatarContainer.trailingAnchor),
                avatarImageView.bottomAnchor.constraint(equalTo: avatarContainer.bottomAnchor)
            ])
            
            // Calculate and set position
            let xPosition = CGFloat(currentColumn) * (circleSize + horizontalSpacing)
            let yPosition = CGFloat(currentRow) * (circleSize + verticalSpacing)
            
            NSLayoutConstraint.activate([
                avatarContainer.leadingAnchor.constraint(equalTo: participantsContainerView.leadingAnchor, constant: xPosition),
                avatarContainer.topAnchor.constraint(equalTo: participantsContainerView.topAnchor, constant: yPosition),
                avatarContainer.widthAnchor.constraint(equalToConstant: circleSize),
                avatarContainer.heightAnchor.constraint(equalToConstant: circleSize)
            ])
            
            currentColumn += 1
            if currentColumn >= circlesPerRow {
                currentColumn = 0
                currentRow += 1
            }
        }
        
        // Update container size
        let rows = ceil(Float(maxPeople) / Float(circlesPerRow))
        let containerHeight = CGFloat(rows) * circleSize + CGFloat(max(0, rows - 1)) * verticalSpacing
        let containerWidth = min(CGFloat(maxPeople), CGFloat(circlesPerRow)) * circleSize +
                            CGFloat(min(maxPeople - 1, circlesPerRow - 1)) * horizontalSpacing
        
        NSLayoutConstraint.activate([
            participantsContainerView.heightAnchor.constraint(equalToConstant: containerHeight),
            participantsContainerView.widthAnchor.constraint(equalToConstant: containerWidth)
        ])
    }

    func setupNoteLabel() {
        noteLabel = UILabel()
        noteLabel.font = .systemFont(ofSize: 16)
        noteLabel.numberOfLines = 0  // Allow multiple lines
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(noteLabel)
    }
    
    
    // Helper methods for image handling
    private func fetchUserProfile(email: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(email).getDocument { snapshot, error in
            if let data = snapshot?.data(),
               let profileImageUrl = data["profileImageUrl"] as? String {
                completion(profileImageUrl)
            } else {
                completion(nil)
            }
        }
    }

    private func loadImage(from urlString: String, into imageView: UIImageView) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                DispatchQueue.main.async {
                    imageView.image = UIImage(data: data)
                }
            }
        }.resume()
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
//            backButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
//            backButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//            backButton.widthAnchor.constraint(equalToConstant: 30),
//            backButton.heightAnchor.constraint(equalToConstant: 30),
//            
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
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
            
            noteLabel.topAnchor.constraint(equalTo: zipCodeLabel.bottomAnchor, constant: 8),
            noteLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            noteLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
                        
            peopleJoinedLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 30),
            peopleJoinedLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            
            participantsContainerView.topAnchor.constraint(equalTo: peopleJoinedLabel.bottomAnchor, constant: 10),
            participantsContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),

            
            buttonStackView.topAnchor.constraint(equalTo: participantsContainerView.bottomAnchor, constant: 30),
            buttonStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40),
            buttonStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            buttonStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
