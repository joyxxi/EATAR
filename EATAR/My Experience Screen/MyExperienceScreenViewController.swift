//
//  MyExperienceScreenViewController.swift
//  EATAR
//
//  Created by Mohan Qi on 11/2/24.
//

import UIKit

class MyExperienceScreenViewController: UIViewController {

    let myExperienceScreen = MyExperienceScreenView()
    var myPosts = [Experience]()
    var joinedExperiences = [Experience]()
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
        
        //Add Sample Data
        myPosts.append(
            Experience(restaurant: "Shang Cafe", cuisine: "Chinese", people: "1/4", time: "10/13/24 Lunch", location: "xx St, San Jose, CA", postedBy: "User1", postedTime: "10/11/24"))
        myPosts.append(
            Experience(restaurant: "Dish & Dash", cuisine: "Mediterran", people: "2/4", time: "10/15/24 Dinner", location: "xx St, Sunnyvale, CA", postedBy: "User2", postedTime: "10/13/24"))
        
        joinedExperiences.append(
            Experience(restaurant: "Pacific Catch", cuisine: "American", people: "1/2", time: "10/16/24 Lunch", location: "xx St, Santa Clara, CA", postedBy: "User3", postedTime: "10/14/24"))
        joinedExperiences.append(
            Experience(restaurant: "Sweetgreen", cuisine: "American", people: "1/3", time: "10/17/24 Lunch", location: "xx St, Santa Clara, CA", postedBy: "User4", postedTime: "10/15/24"))

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.horizontal.3"),
            style: .done,
            target: self,
            action: #selector(onMenuBarButtonTapped)
        )
        
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
        
        let experiences = tableView == myExperienceScreen.tableViewMyPosts ?
                   myPosts[indexPath.row] :
                   joinedExperiences[indexPath.row]
        
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
        
        let buttonOptions = UIButton(type: .system)
        buttonOptions.translatesAutoresizingMaskIntoConstraints = false
        buttonOptions.showsMenuAsPrimaryAction = true
        
        // Configure button size explicitly
        let buttonSize: CGFloat = 30
        NSLayoutConstraint.activate([
            buttonOptions.widthAnchor.constraint(equalToConstant: buttonSize),
            buttonOptions.heightAnchor.constraint(equalToConstant: buttonSize)
        ])
         
        if tableView == myExperienceScreen.tableViewMyPosts {
            // For My Posts - Show Edit and Delete options
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
            buttonOptions.setImage(UIImage(systemName: "ellipsis.circle", withConfiguration: config), for: .normal)
            buttonOptions.menu = UIMenu(title: "Options", children: [
                UIAction(title: "Edit", image: UIImage(systemName: "pencil"), handler: { [weak self] _ in
                    self?.handleEdit(experience: experiences)
                }),
                UIAction(title: "Delete",
                        image: UIImage(systemName: "trash"),
                        attributes: .destructive,
                        handler: { [weak self] _ in
                    self?.handleDelete(experience: experiences)
                })
            ])
        } else {
            // For Joined Experiences - Show Review option
            let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
            buttonOptions.setImage(UIImage(systemName: "star.circle", withConfiguration: config), for: .normal)
            buttonOptions.menu = UIMenu(title: "Options", children: [
                UIAction(title: "Review", image: UIImage(systemName: "star"), handler: { [weak self] _ in
                    self?.handleReview(experience: experiences)
                })
            ])
        }
        
        // Create a container view for the button to help with alignment
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize))
        containerView.addSubview(buttonOptions)
        
        // Center the button in its container
        NSLayoutConstraint.activate([
            buttonOptions.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            buttonOptions.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        cell.accessoryView = containerView
        
        // Ensure the button is vertically centered with the first line (restaurant name)
        containerView.frame.origin.y = cell.labelRestaurant.frame.origin.y
        
        return cell

     }
     
     // MARK: - Helper Methods for Menu Actions
     func handleEdit(experience: Experience) {

     }
     
     func handleDelete(experience: Experience) {

     }
     
     func handleReview(experience: Experience) {
         
     }
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

