//
//  HomeScreenView.swift
//  EATAR
//
//  Created by Mohan Qi on 11/2/24.
//

import UIKit

class HomeScreenView: UIView {
    var contentWrapper:UIScrollView!
    var labelUpcomingExperiences: UILabel!
    var buttonExpand: UIButton!
    var tableViewUpcomingExperiences: UITableView!
    var labelRecommendedExperiences: UILabel!
    var tableViewRecommendedExperiences: UITableView!
    var upcomingExperiencesHeightConstraint: NSLayoutConstraint!
    var labelNoUpcomingExperiences: UILabel!
    var labelNoRecommendedExperiences: UILabel!


    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .white
        
        setupContentWrapper()
        setupContentElements()

        initConstraints()
    }
    

    
    func setupContentWrapper(){
        contentWrapper = UIScrollView()
        contentWrapper.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(contentWrapper)
    }
    
    func setupContentElements(){
        labelUpcomingExperiences = UILabel()
        labelUpcomingExperiences.text = "Upcoming Experiences"
        labelUpcomingExperiences.font = .boldSystemFont(ofSize: 20)
        labelUpcomingExperiences.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelUpcomingExperiences)
        
        buttonExpand = UIButton(type: .system)
        buttonExpand.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        buttonExpand.tintColor = .brown
        buttonExpand.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonExpand)
        
        labelNoUpcomingExperiences = UILabel()
        labelNoUpcomingExperiences.text = "No upcoming dining experiences. Start exploring!"
        labelNoUpcomingExperiences.textColor = .gray
        labelNoUpcomingExperiences.font = .boldSystemFont(ofSize: 16)
        labelNoUpcomingExperiences.isHidden = true
        
        tableViewUpcomingExperiences = UITableView()
        tableViewUpcomingExperiences.register(ExperienceTableViewCell.self, forCellReuseIdentifier: "experiences")
        tableViewUpcomingExperiences.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(tableViewUpcomingExperiences)
        
        labelRecommendedExperiences = UILabel()
        labelRecommendedExperiences.text = "Recommended For You"
        labelRecommendedExperiences.font = .boldSystemFont(ofSize: 20)
        labelRecommendedExperiences.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelRecommendedExperiences)
        
        labelNoRecommendedExperiences = UILabel()
        labelNoRecommendedExperiences.text = "No recommended dining experiences"
        labelNoRecommendedExperiences.textColor = .gray
        labelNoUpcomingExperiences.font = .boldSystemFont(ofSize: 16)
        labelNoRecommendedExperiences.isHidden = true
        
        tableViewRecommendedExperiences = UITableView()
        tableViewRecommendedExperiences.register(ExperienceTableViewCell.self, forCellReuseIdentifier: "experiences")
        tableViewRecommendedExperiences.isScrollEnabled = false
        tableViewRecommendedExperiences.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(tableViewRecommendedExperiences)
    }
    
    func updateUpcomingExperiencesView(hasExperiences: Bool) {
        // Show/hide the table view and no experiences label based on experiences availability
        tableViewUpcomingExperiences.isHidden = !hasExperiences
        
        // Add the "No upcoming experiences" label to the content wrapper if it's not already added
        if labelNoUpcomingExperiences.superview == nil {
            contentWrapper.addSubview(labelNoUpcomingExperiences)
            
            // Add constraints for the "No upcoming experiences" label
            labelNoUpcomingExperiences.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                labelNoUpcomingExperiences.topAnchor.constraint(equalTo: labelUpcomingExperiences.bottomAnchor, constant: 16),
                labelNoUpcomingExperiences.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16)
            ])
        }
        
        // Show/hide the "No upcoming experiences" label
        labelNoUpcomingExperiences.isHidden = hasExperiences
        
        // If no experiences, adjust the height constraint
        upcomingExperiencesHeightConstraint.constant = hasExperiences ? 250 : 0
    }
    
    func updateRecommendedExperiencesView(hasRecommendedExperiences: Bool) {
        // Show/hide the table view and no experiences label based on experiences availability
        tableViewRecommendedExperiences.isHidden = !hasRecommendedExperiences
        
        // Add the "No upcoming experiences" label to the content wrapper if it's not already added
        if labelNoRecommendedExperiences.superview == nil {
            contentWrapper.addSubview(labelNoRecommendedExperiences)
            
            // Add constraints for the "No upcoming experiences" label
            labelNoRecommendedExperiences.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                labelNoRecommendedExperiences.topAnchor.constraint(equalTo: labelRecommendedExperiences.bottomAnchor, constant: 16),
                labelNoRecommendedExperiences.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16)
            ])
        }
        
        // Show/hide the "No upcoming experiences" label
        labelNoRecommendedExperiences.isHidden = hasRecommendedExperiences
    
    }
    
    
    
    func initConstraints() {
        upcomingExperiencesHeightConstraint = tableViewUpcomingExperiences.heightAnchor.constraint(equalToConstant: 250)

        NSLayoutConstraint.activate([
            // Content Wrapper
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            contentWrapper.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            // Important: Set the content wrapper's width equal to the view's width
            contentWrapper.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            // Upcoming Experiences
            labelUpcomingExperiences.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 32),
            labelUpcomingExperiences.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            buttonExpand.centerYAnchor.constraint(equalTo: labelUpcomingExperiences.centerYAnchor),
            buttonExpand.leadingAnchor.constraint(equalTo: labelUpcomingExperiences.trailingAnchor, constant: 8),

            upcomingExperiencesHeightConstraint,
            tableViewUpcomingExperiences.topAnchor.constraint(equalTo: labelUpcomingExperiences.bottomAnchor, constant: 16),
            tableViewUpcomingExperiences.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewUpcomingExperiences.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            labelRecommendedExperiences.topAnchor.constraint(equalTo: tableViewUpcomingExperiences.bottomAnchor, constant: 32),
            labelRecommendedExperiences.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),

            tableViewRecommendedExperiences.topAnchor.constraint(equalTo: labelRecommendedExperiences.bottomAnchor, constant: 16),
            tableViewRecommendedExperiences.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewRecommendedExperiences.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableViewRecommendedExperiences.heightAnchor.constraint(equalTo: contentWrapper.heightAnchor),
            tableViewRecommendedExperiences.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor, constant: -16)
        ])
    }
    
    //MARK: initializing constraints...
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
