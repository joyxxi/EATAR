//
//  ReviewView.swift
//  EATAR
//
//  Created by kangweijia on 2024/11/1.
//

import UIKit

class ReviewView: UIView {
    // MARK: - Properties
    let horizontalPadding: CGFloat = 16
    let buttonHeight: CGFloat = 44
    
    var titleLabel: UILabel!
    var foodRatingView: RatingView!
    var serviceRatingView: RatingView!
    var environmentRatingView: RatingView!
    var reviewTextField: UITextField!
    var addPhotoButton: UIButton!
    var submitButton: UIButton!
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupTitleLabel()
        setupFoodRatingView()
        setupServiceRatingView()
        setupEnvironmentRatingView()
        setupReviewTextField()
        setupAddPhotoButton()
        setupSubmitButton()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI Elements
    func setupTitleLabel() {
        titleLabel = UILabel()
        titleLabel.text = "How was Shang Cafe?"
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    
    func setupFoodRatingView() {
        foodRatingView = RatingView(title: "Food")
        foodRatingView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(foodRatingView)
    }
    
    func setupServiceRatingView() {
        serviceRatingView = RatingView(title: "Service")
        serviceRatingView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(serviceRatingView)
    }
    
    func setupEnvironmentRatingView() {
        environmentRatingView = RatingView(title: "Environment")
        environmentRatingView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(environmentRatingView)
    }
    
    func setupReviewTextField() {
        reviewTextField = UITextField()
        reviewTextField.placeholder = "Write your review"
        reviewTextField.borderStyle = .roundedRect
        reviewTextField.textAlignment = .left
        reviewTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(reviewTextField)
    }
    
    func setupAddPhotoButton() {
        addPhotoButton = UIButton(type: .system)
        addPhotoButton.setImage(UIImage(systemName: "photo.fill.on.rectangle.fill"), for: .normal)
        addPhotoButton.tintColor = .systemGray3
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(addPhotoButton)
    }
    
    func setupSubmitButton() {
        submitButton = UIButton(type: .system)
        submitButton.setTitle("Submit", for: .normal)
        submitButton.backgroundColor = .systemGray3
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.layer.cornerRadius = 5
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(submitButton)
    }
    
    // MARK: - Constraints
    func initConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            
            foodRatingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            foodRatingView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            foodRatingView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            
            serviceRatingView.topAnchor.constraint(equalTo: foodRatingView.bottomAnchor, constant: 24),
            serviceRatingView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            serviceRatingView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            
            environmentRatingView.topAnchor.constraint(equalTo: serviceRatingView.bottomAnchor, constant: 24),
            environmentRatingView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            environmentRatingView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            
            reviewTextField.topAnchor.constraint(equalTo: environmentRatingView.bottomAnchor, constant: 24),
            reviewTextField.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            reviewTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            reviewTextField.heightAnchor.constraint(equalToConstant: buttonHeight * 3),
            
            addPhotoButton.topAnchor.constraint(equalTo: reviewTextField.bottomAnchor, constant: 24),
            addPhotoButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            addPhotoButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            addPhotoButton.widthAnchor.constraint(equalToConstant: buttonHeight),
            
            submitButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            submitButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: horizontalPadding),
            submitButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -horizontalPadding),
            submitButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
}
