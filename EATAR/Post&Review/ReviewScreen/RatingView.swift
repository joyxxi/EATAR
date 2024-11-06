//
//  RatingView.swift
//  EATAR
//
//  Created by kangweijia on 2024/11/1.
//

import UIKit

class RatingView: UIView {
    // MARK: - Properties
    var titleLabel: UILabel!
    var starsStackView: UIStackView!
    var starButtons: [UIButton] = []
    
    // MARK: - Init
    init(title: String) {
        super.init(frame: .zero)
        
        setupTitleLabel(with: title)
        setupStarsStackView()
        
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI Elements
    func setupTitleLabel(with title: String) {
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    
    func setupStarsStackView() {
        starsStackView = UIStackView()
        starsStackView.axis = .horizontal
        starsStackView.spacing = 8
        starsStackView.distribution = .fillEqually
        starsStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(starsStackView)
        
        // Add star buttons
        for _ in 0..<5 {
            let starButton = UIButton()
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            starButton.tintColor = .systemGray3
            starsStackView.addArrangedSubview(starButton)
            starButtons.append(starButton)
        }
    }
    
    // MARK: - Constraints
    func initConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            starsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            starsStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            starsStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            starsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            starsStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
