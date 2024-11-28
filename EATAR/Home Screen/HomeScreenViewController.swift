//
//  HomeScreenViewController.swift
//  EATAR
//
//  Created by Mohan Qi on 11/2/24.
//

import UIKit

class HomeScreenViewController: UIViewController {

    
    let homeScreen = HomeScreenView()
    var upcomingExperiences = [DiningPost]()
    var recommendedExperiences = [DiningPost]()
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        
        //Add Sample Data
        upcomingExperiences.append(
            DiningPost(id: "1", restaurantName: "Shang Cafe", cuisine: "Chinese", maxPeople: 4, currentPeople: 1, dateTime:dateFormatter.date(from: "10/16/2024 12:00")!, location: "xx St, San Jose, CA", zipCode: "94089", note: "", creatorId: "1", participants: ["1"], status: .active, createdAt:dateFormatter.date(from: "10/11/2024 11:00")!))
        upcomingExperiences.append(
            DiningPost(id: "2", restaurantName:"Dish & Dash", cuisine: "Mediterran", maxPeople: 4, currentPeople: 2, dateTime: dateFormatter.date(from: "10/15/2024 12:30")!, location: "xx St, Sunnyvale, CA", zipCode: "94091", note: "", creatorId: "2", participants: ["1", "2"], status: .active, createdAt: dateFormatter.date(from: "10/12/2024 11:00")!))
        
        recommendedExperiences.append(
            DiningPost(id: "3", restaurantName:"Pacific Catch", cuisine: "American", maxPeople: 2, currentPeople: 1, dateTime: dateFormatter.date(from: "10/16/2024 12:00")!, location: "xx St, Santa Clara, CA", zipCode: "94090", note: "", creatorId: "3", participants: ["3"], status: .active, createdAt: dateFormatter.date(from: "10/14/2024 11:00")!))
        recommendedExperiences.append(
            DiningPost(id: "4", restaurantName:"Sweetgreen", cuisine: "American", maxPeople: 3, currentPeople: 1, dateTime: dateFormatter.date(from: "10/17/2024 12:15")!, location: "xx St, Santa Clara, CA", zipCode: "94090", note: "", creatorId: "4", participants: ["4"], status: .active, createdAt: dateFormatter.date(from: "10/15/2024 11:00")!))

        
        //Set up the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add, target: self,
            action: #selector(onAddBarButtonTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .brown

        

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.horizontal.3"),
            style: .done,
            target: self,
            action: #selector(onMenuBarButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .brown

        
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
        let createPostVC = CreatePostViewController()
        let navController = UINavigationController(rootViewController: createPostVC)
        present(navController, animated: true)
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
        
        let post = tableView == homeScreen.tableViewUpcomingExperiences ?
                   upcomingExperiences[indexPath.row] :
                   recommendedExperiences[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "experiences", for: indexPath) as! ExperienceTableViewCell
        cell.labelRestaurant.text = "Restaurant: \(post.restaurantName)"
        cell.labelCuisine.text = "Cuisine: \(post.cuisine)"
        cell.labelPeople.text = "People: \(post.currentPeople) / \(post.maxPeople)"
        cell.labelTime.text = "Time: \(post.dateTime)"
        cell.labelLocation.text = "Location: \(post.location)"
        cell.labelPostedBy.text = "Posted By: \(post.creatorId)"
        cell.labelPostedTime.text = "Posted Time: \(post.createdAt)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let post = tableView == homeScreen.tableViewUpcomingExperiences ?
                   upcomingExperiences[indexPath.row] :
                   recommendedExperiences[indexPath.row]
        
        // Create and push JoinPostViewController
        let joinPostVC = JoinPostViewController(postId: post.id)
        navigationController?.pushViewController(joinPostVC, animated: true)
    }
}

