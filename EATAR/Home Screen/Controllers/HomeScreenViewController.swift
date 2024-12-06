//
//  HomeScreenViewController.swift
//  EATAR
//
//  Created by Mohan Qi on 11/2/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Foundation

class HomeScreenViewController: UIViewController {
    let database = Firestore.firestore()


    let homeScreen = HomeScreenView()
    var upcomingExperiences = [DiningPost]()
    var recommendedExperiences = [DiningPost]()
    var isUpcomingExpanded = true
    var upcomingExperiencesHeightConstraint: NSLayoutConstraint!
    var isSlideInMenuPresented = false
    let userEmail = Auth.auth().currentUser?.email
    let locationManager = LocationManager()
    
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
        
        NotificationCenter.default.addObserver(self,
                                                 selector: #selector(handlePostUpdate),
                                                 name: .didUpdatePost,
                                                 object: nil)
        
        homeScreen.tableViewUpcomingExperiences.dataSource = self
        homeScreen.tableViewUpcomingExperiences.delegate = self
        homeScreen.tableViewUpcomingExperiences.separatorStyle = .none
        
        homeScreen.tableViewRecommendedExperiences.dataSource = self
        homeScreen.tableViewRecommendedExperiences.delegate = self
        homeScreen.tableViewRecommendedExperiences.separatorStyle = .none

        fetchUpcomingExperiences()
        fetchRecommendedExperiences()
        
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
        
        // Get location
        locationManager.checkLocationAuthorization()
        
        // Check if profile needs update
        checkProfileUpdate()
        
    }

    
    @objc func handlePostUpdate() {
        fetchUpcomingExperiences()
        fetchRecommendedExperiences()
        
        DispatchQueue.main.async {
            self.homeScreen.tableViewUpcomingExperiences.reloadData()
            self.homeScreen.tableViewRecommendedExperiences.reloadData()
        }
    }

    
    func checkProfileUpdate() {
        let userRef = database.collection("users").document(userEmail ?? "")
        userRef.getDocument() { document, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                return
            }
            guard let document = document, document.exists else {
                print("User does not exist.")
                return
            }
            
            if let hasProfile = document.get("hasProfile") as? Bool {
                if !hasProfile {
                    showUpdateProfileReminder(on: self)
                }
            } else {
                print("'hasProfile' field is missing or not a boolean.")
            }
        }
    }

    
    func fetchUpcomingExperiences() {
        guard let userEmail = Auth.auth().currentUser?.email else { return }
        
        database.collection("posts")
            .whereField("participants", arrayContains: userEmail)
            .whereField("status", isEqualTo: DiningPost.PostStatus.active.rawValue)
            .whereField("dateTime", isGreaterThan: Date())
            .order(by: "dateTime")
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching upcoming experiences: \(error.localizedDescription)")
                    return
                }
                
                self.upcomingExperiences = snapshot?.documents.compactMap { DiningPost.fromFirestore($0) } ?? []
                
                print("DEBUG: Fetched Upcoming count after join: \(self.upcomingExperiences.count)")  // Add this debug line
                
                DispatchQueue.main.async {
                    self.homeScreen.tableViewUpcomingExperiences.reloadData()
                    if self.upcomingExperiences.count == 0 {
                        self.homeScreen.updateUpcomingExperiencesView(hasExperiences: false)
                    }
                }
            }
    }
    
    func fetchRecommendedExperiences() {
        guard let currentUser = Auth.auth().currentUser else { return }
        guard let userEmail =  Auth.auth().currentUser?.email else { return }

            
        // Extract user zipcode
        self.database.collection("users").document(userEmail).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            guard let data = snapshot?.data() else { return }
            
            // Safely extract userZipCode
            guard let userZipCode = Profile(from: data)?.location else {
                print("DEBUG: No zipcode found for user")
                return
            }
            
            print("DEBUG: User Zipcode: \(userZipCode)")
            
            // Query recommended experiences
            self.database.collection("posts")
                .whereField("status", isEqualTo: DiningPost.PostStatus.active.rawValue)
                .whereField("dateTime", isGreaterThan: Date())
                .whereField("zipCode", isGreaterThanOrEqualTo: userZipCode.prefix(2) + "000")
                .whereField("zipCode",  isLessThan: userZipCode.prefix(2) + "999")
                .getDocuments { [weak self] snapshot, error in
                    guard let self = self else { return }
                    
                    if let error = error {
                        print("Error fetching recommended experiences: \(error.localizedDescription)")
                        return
                    }
                    
                    print("DEBUG: Total recommended documents retrieved: \(snapshot?.documents.count ?? 0)")
                    
                    
                    // Filter out posts the user has already joined & posts that are full
                    self.recommendedExperiences = (snapshot?.documents.compactMap { DiningPost.fromFirestore($0) } ?? [])
                        .filter { post in
                            !post.participants.contains(currentUser.email ?? "") &&
                            post.creatorId != currentUser.uid &&
                            post.currentPeople < post.maxPeople
                        }
                    
                    // If no experience matched the recommendation logic
                    if self.recommendedExperiences.isEmpty {
                        print("DEBUG: No recommended posts. Fetching all active posts...")
                        self.fetchAllActivePosts(excluding: currentUser)
                    } else {
                        print("DEBUG: Recommended Experiences count: \(self.recommendedExperiences.count)")
                        DispatchQueue.main.async {
                            self.homeScreen.tableViewRecommendedExperiences.reloadData()
                        }
                    }
                }
        }
    }
    
    func fetchAllActivePosts(excluding currentUser: User) {
        self.database.collection("posts")
            .whereField("status", isEqualTo: DiningPost.PostStatus.active.rawValue)
            .whereField("dateTime", isGreaterThan: Date())
            .order(by: "dateTime")
            .getDocuments { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error fetching all active posts: \(error.localizedDescription)")
                    return
                }
                
                print("DEBUG: Total active documents retrieved: \(snapshot?.documents.count ?? 0)")

                // Filter out posts the user has already joined & posts that are full
                self.recommendedExperiences = (snapshot?.documents.compactMap { DiningPost.fromFirestore($0) } ?? [])
                    .filter { post in
                        !post.participants.contains(currentUser.email ?? "") &&
                        post.creatorId != currentUser.uid &&
                        post.currentPeople < post.maxPeople
                    }
                
                if self.recommendedExperiences.count == 0{
                    self.homeScreen.updateRecommendedExperiencesView(hasRecommendedExperiences: false)
                }
                
                print("DEBUG: All Active Experiences count: \(self.recommendedExperiences.count)")
                DispatchQueue.main.async {
                    self.homeScreen.tableViewRecommendedExperiences.reloadData()
                }
            }
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
        menuView.addMenuItem(title: "Log Out", target: self, action: #selector(onLogoutTapped))
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
        let profileDetailVC = ProfileDetailViewController()
        navigationController?.pushViewController(profileDetailVC, animated: true)
//        profileDetailVC.navigationItem.hidesBackButton = true
    }
    
    @objc func onLogoutTapped(){
        UserDefaults.standard.removeObject(forKey: "userToken")
            
        let loginVC = SignInViewController()
        navigationController?.pushViewController(loginVC, animated: true)
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy HH:mm"
        cell.labelRestaurant.text = "Restaurant: \(post.restaurantName)"
        cell.labelCuisine.text = "Cuisine: \(post.cuisine)"
        cell.labelPeople.text = "People: \(post.currentPeople) / \(post.maxPeople)"
        cell.labelTime.text = "Time: \(dateFormatter.string(from: post.dateTime))"
        cell.labelLocation.text = "Location: \(post.location)"
        cell.labelPostedBy.text = "Posted By: \(post.creatorId)"
        cell.labelPostedTime.text = "Posted Time: \(dateFormatter.string(from: post.createdAt))"

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

