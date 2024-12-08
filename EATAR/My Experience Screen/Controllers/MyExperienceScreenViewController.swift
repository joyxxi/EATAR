//
//  MyExperienceScreenViewController.swift
//  EATAR
//
//  Created by Mohan Qi on 11/2/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MyExperienceScreenViewController: UIViewController {
    let database = Firestore.firestore()

    let myExperienceScreen = MyExperienceScreenView()
    var myPosts = [DiningPost]()
    var joinedExperiences = [DiningPost]()
    var isMyPostExpanded = true
    var isJoinedExperienceExpanded = true
    var myPostsHeightConstraint: NSLayoutConstraint!
    var joinedExperienceHeightConstraint: NSLayoutConstraint!
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
        
        title = "My Experiences"
        
        myExperienceScreen.tableViewMyPosts.dataSource = self
        myExperienceScreen.tableViewMyPosts.delegate = self
        myExperienceScreen.tableViewMyPosts.separatorStyle = .none
        
        myExperienceScreen.tableViewJoinedExperience.dataSource = self
        myExperienceScreen.tableViewJoinedExperience.delegate = self
        myExperienceScreen.tableViewJoinedExperience.separatorStyle = .none
        
        fetchMyPosts()
        fetchJoinedExperiences()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.horizontal.3"),
            style: .done,
            target: self,
            action: #selector(onMenuBarButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .brown

        setupMenuItems()
        
        myExperienceScreen.buttonExpand1.addTarget(self, action: #selector(onExpandButtonTapped), for: .touchUpInside)
        
        myExperienceScreen.buttonExpand2.addTarget(self, action: #selector(onExpandButton2Tapped), for: .touchUpInside)
        
        myPostsHeightConstraint = myExperienceScreen.tableViewMyPosts.heightAnchor.constraint(equalToConstant: 250)
                myPostsHeightConstraint.isActive = true
        
        joinedExperienceHeightConstraint = myExperienceScreen.tableViewJoinedExperience.heightAnchor.constraint(equalToConstant: 250)
        joinedExperienceHeightConstraint.isActive = true
        
    }
    
    func fetchMyPosts() {
        guard let userEmail =  Auth.auth().currentUser?.email else { return }
        
        database.collection("posts")
            .whereField("creatorId", isEqualTo: userEmail)
             .whereField("status", isEqualTo: DiningPost.PostStatus.active.rawValue )
             .order(by: "dateTime")
             .getDocuments { [weak self] snapshot, error in
                 guard let self = self else { return }
                 
                 if let error = error {
                     print("Error fetching my posts: \(error.localizedDescription)")
                     return
                 }
                 
                 self.myPosts = snapshot?.documents.compactMap { DiningPost.fromFirestore($0) } ?? []
                 
                 if self.myPosts.count == 0{
                     self.myExperienceScreen.updateMyPosts(hasMyPosts: false)
                 }

                 print("DEBUG: My Posts count: \(self.myPosts.count)")
                 
                 DispatchQueue.main.async {
                     self.myExperienceScreen.tableViewMyPosts.reloadData()
                 }
             }
     }
    
    func fetchJoinedExperiences() {
        guard let userEmail =  Auth.auth().currentUser?.email else { return }
        print("DEBUG: JoinedExperience User Email: \(userEmail)")
        
        database.collection("posts")
            .whereField("participants", arrayContains: userEmail)
            .whereField("status", isEqualTo: DiningPost.PostStatus.completed.rawValue )
             .order(by: "dateTime", descending: true)
             .getDocuments { [weak self] snapshot, error in
                 guard let self = self else { return }
                 
                 if let error = error {
                     print("Error fetching joined experience: \(error.localizedDescription)")
                     return
                 }
                 
                 self.joinedExperiences = snapshot?.documents.compactMap { DiningPost.fromFirestore($0) } ?? []
                 
                 if self.joinedExperiences.count == 0{
                     self.myExperienceScreen.updateJoinedExperiences(hasJoinedExperiences: false)
                 }

                 print("DEBUG: Joined Experience count: \(self.joinedExperiences.count)")
                 print(self.joinedExperiences)
                 
                 DispatchQueue.main.async {
                     self.myExperienceScreen.tableViewJoinedExperience.reloadData()
                 }
             }
     }
    
    func setupViewHierarchy() {
        view = UIView()
        view.addSubview(menuView)
        view.addSubview(containerView)
        containerView.addSubview(myExperienceScreen)
        myExperienceScreen.translatesAutoresizingMaskIntoConstraints = false
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
            
            // MyExperienceScreen constraints
            myExperienceScreen.topAnchor.constraint(equalTo: containerView.topAnchor),
            myExperienceScreen.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            myExperienceScreen.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            myExperienceScreen.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    @objc func onExpandButtonTapped() {
        isMyPostExpanded.toggle()
        updateTableHeight()
    }
    
    func updateTableHeight(){
        myPostsHeightConstraint.constant = isMyPostExpanded ? 250 : 0 // Collapsed height set to 0

        let newImage = isMyPostExpanded ?
                    UIImage(systemName: "chevron.up") :
                    UIImage(systemName: "chevron.down")
        
        UIView.animate(withDuration: 0.3) {
            self.myExperienceScreen.buttonExpand1.setImage(newImage, for: .normal)
            self.myExperienceScreen.layoutIfNeeded() // Update the layout
         }
    }
    
    @objc func onExpandButton2Tapped() {
        isJoinedExperienceExpanded.toggle()
        updateTableHeight2()
    }
    
    func updateTableHeight2(){
        joinedExperienceHeightConstraint.constant = isJoinedExperienceExpanded ? 250 : 0

        let newImage = isJoinedExperienceExpanded ?
                    UIImage(systemName: "chevron.up") :
                    UIImage(systemName: "chevron.down")
        
        UIView.animate(withDuration: 0.3) {
            self.myExperienceScreen.buttonExpand2.setImage(newImage, for: .normal)
            self.myExperienceScreen.layoutIfNeeded() // Update the layout
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
        // Implement navigation logic to Profile
        let profileDetailVC = ProfileDetailViewController()
        navigationController?.pushViewController(profileDetailVC, animated: true)
    }
    
    @objc func onLogoutTapped(){
        UserDefaults.standard.removeObject(forKey: "userToken")
            
        let loginVC = SignInViewController()
        navigationController?.pushViewController(loginVC, animated: true)
    }


}

extension MyExperienceScreenViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == myExperienceScreen.tableViewMyPosts {
            return myPosts.count
        } else {
            return joinedExperiences.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = tableView == myExperienceScreen.tableViewMyPosts ?
                   myPosts[indexPath.row] :
                   joinedExperiences[indexPath.row]
        
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
        
        
        if tableView == myExperienceScreen.tableViewMyPosts {
            // For My Posts - Show Edit and Delete options
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
            cell.buttonOptions.setImage(UIImage(systemName: "ellipsis.circle", withConfiguration: config), for: .normal)
            cell.buttonOptions.tintColor = .brown
            cell.buttonOptions.menu = UIMenu(title: "Options", children: [
                UIAction(title: "Edit", image: UIImage(systemName: "pencil"), handler: { [weak self] _ in
                    self?.handleEdit(experience: post)
                }),
                UIAction(title: "Delete",
                        image: UIImage(systemName: "trash"),
                        attributes: .destructive,
                        handler: { [weak self] _ in
                    self?.handleDelete(experience: post)
                })
            ])
        } else {
            // For Joined Experiences - Show Review option
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
            cell.buttonOptions.setImage(UIImage(systemName: "star.circle", withConfiguration: config), for: .normal)
            cell.buttonOptions.tintColor = .brown
            cell.buttonOptions.menu = UIMenu(title: "Options", children: [
                UIAction(title: "Review", image: UIImage(systemName: "star"), handler: { [weak self] _ in
                    self?.handleReview(experience: post)
                })
            ])
        }
        cell.accessoryView = cell.buttonOptions
        
        return cell

     }
     
     // MARK: - Helper Methods for Menu Actions
    func handleEdit(experience: DiningPost) {
        let editPostVC = EditPostViewController(postId: experience.id)
        let navController = UINavigationController(rootViewController: editPostVC)
        present(navController, animated: true)
     }
     
    func handleDelete(experience: DiningPost) {
        // Show confirmation alert before deleting
        let alert = UIAlertController(
            title: "Delete Post",
            message: "Are you sure you want to delete this dining experience?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            
            // Show loading indicator
            let loadingIndicator = UIActivityIndicatorView(style: .large)
            loadingIndicator.center = self.view.center
            self.view.addSubview(loadingIndicator)
            loadingIndicator.startAnimating()
            
            // Delete from Firestore
            self.database.collection("posts").document(experience.id).delete { [weak self] error in
                guard let self = self else { return }
                
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
                
                if let error = error {
                    self.showAlert(message: "Error deleting post: \(error.localizedDescription)")
                    return
                }
                
                // Remove from local array and update UI
                if let index = self.myPosts.firstIndex(where: { $0.id == experience.id }) {
                    self.myPosts.remove(at: index)
                    self.myExperienceScreen.tableViewMyPosts.reloadData()
                }
                
                self.showAlert(message: "Post deleted successfully")
            }
        })
        
        present(alert, animated: true)
    }
    
    // Add helper method for alerts
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
     
    func handleReview(experience: DiningPost) {
        let reviewVC = ReviewViewController(postId: experience.id, restaurantName: experience.restaurantName)
        let navController = UINavigationController(rootViewController: reviewVC)
        present(navController, animated: true)
     }
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            
        let post = tableView == myExperienceScreen.tableViewMyPosts ?
                    myPosts[indexPath.row] :
                    joinedExperiences[indexPath.row]
            
        // Navigate to JoinPostViewController to show details
        let detailVC = JoinPostViewController(postId: post.id)
        navigationController?.pushViewController(detailVC, animated: true)


    }
}

