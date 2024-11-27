//
//  MyExperienceScreenView.swift
//  EATAR
//
//  Created by Mohan Qi on 11/2/24.
//

import UIKit

class MyExperienceScreenView: UIView {

    var contentWrapper:UIScrollView!
    var labelMyPosts: UILabel!
    var buttonExpand1: UIButton!
    var tableViewMyPosts: UITableView!
    var labelJoinedExperience: UILabel!
    var buttonExpand2: UIButton!
    var tableViewJoinedExperience: UITableView!
    var MyPostsHeightConstraint: NSLayoutConstraint!
    var JoinedExperienceHeightConstraint: NSLayoutConstraint!



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
        labelMyPosts = UILabel()
        labelMyPosts.text = "My Posts"
        labelMyPosts.font = .boldSystemFont(ofSize: 18)
        labelMyPosts.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelMyPosts)
        
        buttonExpand1 = UIButton(type: .system)
        buttonExpand1.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        buttonExpand1.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonExpand1)
        
        tableViewMyPosts = UITableView()
        tableViewMyPosts.register(ExperienceTableViewCell.self, forCellReuseIdentifier: "experiences")
        tableViewMyPosts.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(tableViewMyPosts)
        
        labelJoinedExperience = UILabel()
        labelJoinedExperience.text = "Experiences I Joined"
        labelJoinedExperience.font = .boldSystemFont(ofSize: 18)
        labelJoinedExperience.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(labelJoinedExperience)
        
        buttonExpand2 = UIButton(type: .system)
        buttonExpand2.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        buttonExpand2.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(buttonExpand2)
        
        tableViewJoinedExperience = UITableView()
        tableViewJoinedExperience.register(ExperienceTableViewCell.self, forCellReuseIdentifier: "experiences")
        tableViewJoinedExperience.translatesAutoresizingMaskIntoConstraints = false
        contentWrapper.addSubview(tableViewJoinedExperience)
    }
    
    func initConstraints() {
        MyPostsHeightConstraint = tableViewMyPosts.heightAnchor.constraint(equalToConstant: 250)
        JoinedExperienceHeightConstraint = tableViewJoinedExperience.heightAnchor.constraint(equalToConstant: 250)

        NSLayoutConstraint.activate([
            // Content Wrapper
            contentWrapper.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            contentWrapper.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            contentWrapper.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            contentWrapper.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            // Important: Set the content wrapper's width equal to the view's width
            contentWrapper.widthAnchor.constraint(equalTo: self.widthAnchor),
            
            // Upcoming Experiences
            labelMyPosts.topAnchor.constraint(equalTo: contentWrapper.topAnchor, constant: 32),
            labelMyPosts.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            buttonExpand1.centerYAnchor.constraint(equalTo: labelMyPosts.centerYAnchor),
            buttonExpand1.leadingAnchor.constraint(equalTo: labelMyPosts.trailingAnchor, constant: 8),
            
            MyPostsHeightConstraint,
            tableViewMyPosts.topAnchor.constraint(equalTo: labelMyPosts.bottomAnchor, constant: 16),
            tableViewMyPosts.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewMyPosts.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            labelJoinedExperience.topAnchor.constraint(equalTo: tableViewMyPosts.bottomAnchor, constant: 32),
            labelJoinedExperience.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            buttonExpand2.centerYAnchor.constraint(equalTo: labelJoinedExperience.centerYAnchor),
            buttonExpand2.leadingAnchor.constraint(equalTo: labelJoinedExperience.trailingAnchor, constant: 8),
            
            JoinedExperienceHeightConstraint,
            tableViewJoinedExperience.topAnchor.constraint(equalTo: labelJoinedExperience.bottomAnchor, constant: 16),
            tableViewJoinedExperience.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableViewJoinedExperience.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            //tableViewJoinedExperience.bottomAnchor.constraint(equalTo: contentWrapper.bottomAnchor, constant: -16)
        ])
    }
    
    //MARK: initializing constraints...
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
