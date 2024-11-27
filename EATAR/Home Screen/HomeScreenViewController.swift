//
//  HomeScreenViewController.swift
//  EATAR
//
//  Created by Mohan Qi on 11/2/24.
//

import UIKit

class HomeScreenViewController: UIViewController {

    
    let homeScreen = HomeScreenView()
    var upcomingExperiences = [Experience]()
    var recommendedExperiences = [Experience]()
    var isUpcomingExpanded = true
    var upcomingExperiencesHeightConstraint: NSLayoutConstraint!
    var isSlideInMenuPresented = false
    
    let menuView: MenuView = {
        let view = MenuView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()


    override func loadView() {
        super.loadView()
        setupViewHierarchy()
        setupConstraints()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Home"
        
        homeScreen.tableViewUpcomingExperiences.dataSource = self
        homeScreen.tableViewUpcomingExperiences.delegate = self
        homeScreen.tableViewUpcomingExperiences.separatorStyle = .none
        
        homeScreen.tableViewRecommendedExperiences.dataSource = self
        homeScreen.tableViewRecommendedExperiences.delegate = self
        homeScreen.tableViewRecommendedExperiences.separatorStyle = .none
        
        //Add Sample Data
        upcomingExperiences.append(
            Experience(restaurant: "Shang Cafe", cuisine: "Chinese", people: "1/4", time: "10/13/24 Lunch", location: "xx St, San Jose, CA", postedBy: "User1", postedTime: "10/11/24"))
        upcomingExperiences.append(
            Experience(restaurant: "Dish & Dash", cuisine: "Mediterran", people: "2/4", time: "10/15/24 Dinner", location: "xx St, Sunnyvale, CA", postedBy: "User2", postedTime: "10/13/24"))
        
        recommendedExperiences.append(
            Experience(restaurant: "Pacific Catch", cuisine: "American", people: "1/2", time: "10/16/24 Lunch", location: "xx St, Santa Clara, CA", postedBy: "User3", postedTime: "10/14/24"))
        recommendedExperiences.append(
            Experience(restaurant: "Sweetgreen", cuisine: "American", people: "1/3", time: "10/17/24 Lunch", location: "xx St, Santa Clara, CA", postedBy: "User4", postedTime: "10/15/24"))
        
        //Set up the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self,
            action: #selector(onAddBarButtonTapped)
        )
        

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.horizontal.3"),
            style: .done,
            target: self,
            action: #selector(onMenuBarButtonTapped)
        )
        
        setupMenuItems()
        
        //Expand button for Upcoming Experiences
        homeScreen.buttonExpand.addTarget(self, action: #selector(onExpandButtonTapped), for: .touchUpInside)
        
        upcomingExperiencesHeightConstraint = homeScreen.tableViewUpcomingExperiences.heightAnchor.constraint(equalToConstant: 250)
                upcomingExperiencesHeightConstraint.isActive = true
        
    }
    func setupViewHierarchy() {
        view = UIView()
        view.addSubview(menuView)
        view.addSubview(containerView)
        containerView.addSubview(homeScreen)
        homeScreen.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Menu constraints
            menuView.topAnchor.constraint(equalTo: view.topAnchor),
            menuView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            menuView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            menuView.widthAnchor.constraint(equalToConstant: 200),
            
            // Container constraints
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // HomeScreen constraints
            homeScreen.topAnchor.constraint(equalTo: containerView.topAnchor),
            homeScreen.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            homeScreen.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            homeScreen.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    @objc func onExpandButtonTapped() {
        isUpcomingExpanded.toggle()
        updateTableHeight()
    }
    
    func updateTableHeight(){
        upcomingExperiencesHeightConstraint.constant = isUpcomingExpanded ? 250 : 0 // Collapsed height set to 0

        let newImage = isUpcomingExpanded ?
                    UIImage(systemName: "chevron.up") :
                    UIImage(systemName: "chevron.down")
        
        UIView.animate(withDuration: 0.3) {
            self.homeScreen.buttonExpand.setImage(newImage, for: .normal)
            self.homeScreen.layoutIfNeeded() // Update the layout
         }
    }
    
    @objc func onAddBarButtonTapped(){
        
    }
    
    @objc func onMenuBarButtonTapped(){
        let menuWidth = menuView.frame.width
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
            self.containerView.frame.origin.x = self.isSlideInMenuPresented ? 0 : menuWidth
        } completion: { (finished) in
            self.isSlideInMenuPresented.toggle()
        }
    }
    
    func setupMenuItems() {
        menuView.addMenuItem(title: "Home", target: self, action: #selector(onHomeTapped))
       menuView.addMenuItem(title: "My Experiences", target: self, action: #selector(onMyExperiencesTapped))
       menuView.addMenuItem(title: "Profile", target: self, action: #selector(onProfileTapped))
   }

    
    @objc func onHomeTapped() {
        let homeScreenVC = HomeScreenViewController()
        navigationController?.pushViewController(homeScreenVC, animated: true)
        homeScreenVC.navigationItem.hidesBackButton = true
    }
    
    @objc func onMyExperiencesTapped() {
        let myExperienceVC = MyExperienceScreenViewController()
        navigationController?.pushViewController(myExperienceVC, animated: true)
        myExperienceVC.navigationItem.hidesBackButton = true
    }
    
    @objc func onProfileTapped() {
        print("Profile tapped")
        // Implement navigation logic to Profile
    }
    


}

extension HomeScreenViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == homeScreen.tableViewUpcomingExperiences {
            return upcomingExperiences.count
        } else {
            return recommendedExperiences.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let experiences = tableView == homeScreen.tableViewUpcomingExperiences ?
                   upcomingExperiences[indexPath.row] :
                   recommendedExperiences[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "experiences", for: indexPath) as! ExperienceTableViewCell
        if let uwRestaurant = experiences.restaurant{
            cell.labelRestaurant.text = "Restaurant: \(uwRestaurant)"
        }
        if let uwCuisine = experiences.cuisine{
            cell.labelCuisine.text = "Cuisine: \(uwCuisine)"
        }
        if let uwPeople = experiences.people{
            cell.labelPeople.text = "People: \(uwPeople)"
        }
        if let uwTime = experiences.time{
            cell.labelTime.text = "Time: \(uwTime)"
        }
        if let uwLocation = experiences.location{
            cell.labelLocation.text = "Location: \(uwLocation)"
        }
        if let uwPostedBy = experiences.postedBy{
            cell.labelPostedBy.text = "Posted By: \(uwPostedBy)"
        }
        if let uwPostedTime = experiences.postedTime{
            cell.labelPostedTime.text = "Posted Time: \(uwPostedTime)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

