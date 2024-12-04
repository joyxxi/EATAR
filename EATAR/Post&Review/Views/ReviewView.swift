//
//  Untitled.swift
//  EATAR
//
//  Created by kangweijia on 2024/11/26.
//

import UIKit
import FirebaseFirestore

class ReviewView: UIView {
    
//    var backButton: UIButton!
    var titleLabel: UILabel!
    var foodRatingView: RatingView!
    var serviceRatingView: RatingView!
    var environmentRatingView: RatingView!
    var reviewTextView: UITextView!
    var addPhotoButton: UIButton!
    var submitButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
//        setupBackButton()
        setupTitleLabel()
        setupRatingViews()
        setupReviewTextView()
        setupAddPhotoButton()
        setupSubmitButton()
        
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
        titleLabel.text = "How was Shang Cafe?"
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    
    func setupRatingViews() {
        foodRatingView = RatingView(title: "Food")
        serviceRatingView = RatingView(title: "Service")
        environmentRatingView = RatingView(title: "Environment")
        
        self.addSubview(foodRatingView)
        self.addSubview(serviceRatingView)
        self.addSubview(environmentRatingView)
    }
    
    func setupReviewTextView() {
        reviewTextView = UITextView()
        reviewTextView.layer.borderWidth = 1
        reviewTextView.layer.borderColor = UIColor.systemGray4.cgColor
        reviewTextView.layer.cornerRadius = 5
        reviewTextView.font = .systemFont(ofSize: 16)
        reviewTextView.backgroundColor = UIColor(red: 246/255, green: 241/255, blue: 236/255, alpha: 1.0)
        reviewTextView.translatesAutoresizingMaskIntoConstraints = false
        reviewTextView.text = "Review"
        reviewTextView.textColor = .lightGray
        self.addSubview(reviewTextView)
    }
    
    func setupAddPhotoButton() {
        addPhotoButton = UIButton(type: .system)
        addPhotoButton.setImage(UIImage(systemName: "photo.fill.on.rectangle.fill"), for: .normal)
        addPhotoButton.setTitle(" Add Photos", for: .normal)
        addPhotoButton.tintColor = .systemBrown
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addPhotoButton)
    }
    
    func setupSubmitButton() {
        submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = .systemBrown
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 8
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(submitButton)
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
            
            foodRatingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            foodRatingView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            foodRatingView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            foodRatingView.heightAnchor.constraint(equalToConstant: 40),
            
            serviceRatingView.topAnchor.constraint(equalTo: foodRatingView.bottomAnchor, constant: 20),
            serviceRatingView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            serviceRatingView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            serviceRatingView.heightAnchor.constraint(equalToConstant: 40),
            
            environmentRatingView.topAnchor.constraint(equalTo: serviceRatingView.bottomAnchor, constant: 20),
            environmentRatingView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            environmentRatingView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            environmentRatingView.heightAnchor.constraint(equalToConstant: 40),
            
            reviewTextView.topAnchor.constraint(equalTo: environmentRatingView.bottomAnchor, constant: 30),
            reviewTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            reviewTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            reviewTextView.heightAnchor.constraint(equalToConstant: 150),
            
            addPhotoButton.topAnchor.constraint(equalTo: reviewTextView.bottomAnchor, constant: 20),
            addPhotoButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            addPhotoButton.heightAnchor.constraint(equalToConstant: 44),
            
            submitButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            submitButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            submitButton.widthAnchor.constraint(equalToConstant: 200),
            submitButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

// Helper class for rating views
class RatingView: UIView {
    private var titleLabel: UILabel!
    private var starStackView: UIStackView!
    private var rating: Int = 0
    
    init(title: String) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupView(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(title: String) {
        // Title Label
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
        
        // Star Stack View
        starStackView = UIStackView()
        starStackView.axis = .horizontal
        starStackView.spacing = 8
        starStackView.distribution = .fillEqually
        starStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(starStackView)
        
        // Add star buttons
        for i in 1...5 {
            let starButton = UIButton(type: .system)
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            starButton.tintColor = .systemBrown
            starButton.tag = i
            starButton.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            starStackView.addArrangedSubview(starButton)
        }
        
        // Setup constraints
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 100),
            
            starStackView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20),
            starStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            starStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            starStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc private func starTapped(_ sender: UIButton) {
        let newRating = sender.tag
        rating = newRating
        
        // Update star images
        for i in 0..<starStackView.arrangedSubviews.count {
            if let starButton = starStackView.arrangedSubviews[i] as? UIButton {
                let imageName = i < newRating ? "star.fill" : "star"
                starButton.setImage(UIImage(systemName: imageName), for: .normal)
            }
        }
    }
    
    // Method to get current rating
    func getCurrentRating() -> Int {
        return rating
    }
}
