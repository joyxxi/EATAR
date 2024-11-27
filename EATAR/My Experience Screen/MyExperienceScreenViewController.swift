//
//  MyExperienceScreenViewController.swift
//  EATAR
//
//  Created by Mohan Qi on 11/2/24.
//

import UIKit

class MyExperienceScreenViewController: UIViewController {

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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        //Add Sample Data
        myPosts.append(
            DiningPost(id: "1", restaurantName: "Shang Cafe", cuisine: "Chinese", maxPeople: 4, currentPeople: 1, dateTime:dateFormatter.date(from: "10/16/2024 12:00")!, location: "xx St, San Jose, CA", zipCode: "94089", note: "", creatorId: "1", participants: ["1"], status: .active, createdAt:dateFormatter.date(from: "10/11/2024 11:00")!))
        myPosts.append(
            DiningPost(id: "2", restaurantName:"Dish & Dash", cuisine: "Mediterran", maxPeople: 4, currentPeople: 2, dateTime: dateFormatter.date(from: "10/15/2024 12:30")!, location: "xx St, Sunnyvale, CA", zipCode: "94091", note: "", creatorId: "2", participants: ["1", "2"], status: .active, createdAt: dateFormatter.date(from: "10/12/2024 11:00")!))
        
        joinedExperiences.append(
            DiningPost(id: "3", restaurantName:"Pacific Catch", cuisine: "American", maxPeople: 2, currentPeople: 1, dateTime: dateFormatter.date(from: "10/16/2024 12:00")!, location: "xx St, Santa Clara, CA", zipCode: "94090", note: "", creatorId: "3", participants: ["3"], status: .active, createdAt: dateFormatter.date(from: "10/14/2024 11:00")!))
        joinedExperiences.append(
            DiningPost(id: "4", restaurantName:"Sweetgreen", cuisine: "American", maxPeople: 3, currentPeople: 1, dateTime: dateFormatter.date(from: "10/17/2024 12:15")!, location: "xx St, Santa Clara, CA", zipCode: "94090", note: "", creatorId: "4", participants: ["4"], status: .active, createdAt: dateFormatter.date(from: "10/15/2024 11:00")!))

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
        cell.labelRestaurant.text = "Restaurant: \(post.restaurantName)"
        cell.labelCuisine.text = "Cuisine: \(post.cuisine)"
        cell.labelPeople.text = "People: \(post.currentPeople) / \(post.maxPeople)"
        cell.labelTime.text = "Time: \(post.dateTime)"
        cell.labelLocation.text = "Location: \(post.location)"
        cell.labelPostedBy.text = "Posted By: \(post.creatorId)"
        cell.labelPostedTime.text = "Posted Time: \(post.createdAt)"
        
        
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

     }
     
    func handleDelete(experience: DiningPost) {

     }
     
    func handleReview(experience: DiningPost) {
         
     }
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

