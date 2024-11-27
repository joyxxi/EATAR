//
//  ExperienceTableViewCell.swift
//  EATAR
//
//  Created by Mohan Qi on 11/3/24.
//

import UIKit

class ExperienceTableViewCell: UITableViewCell {
    
    var wrapperCellView: UIView!
    var buttonOptions: UIButton!
    var labelRestaurant: UILabel!
    var labelCuisine: UILabel!
    var labelPeople: UILabel!
    var labelTime: UILabel!
    var labelLocation: UILabel!
    var labelPostedBy: UILabel!
    var labelPostedTime: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupWrapperCellView()
        setupButtonOptions()
        setupLabelRestaurant()
        setupLabelCuisine()
        setupLabelPeople()
        setupLabelTime()
        setupLabelLocation()
        setupLabelPostedBy()
        setupLabelPostedTime()
        
        initConstraints()
    }
    
    func setupWrapperCellView(){
        wrapperCellView = UITableViewCell()
        
        //working with the shadows and colors...
        wrapperCellView.backgroundColor = .white
        wrapperCellView.layer.cornerRadius = 4.0
        wrapperCellView.layer.shadowColor = UIColor.gray.cgColor
        wrapperCellView.layer.shadowOffset = .zero
        wrapperCellView.layer.shadowRadius = 2.0
        wrapperCellView.layer.shadowOpacity = 0.7
        wrapperCellView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(wrapperCellView)
    }
    
    func setupButtonOptions() {
        buttonOptions = UIButton(type: .system)
        buttonOptions.translatesAutoresizingMaskIntoConstraints = false
        buttonOptions.isUserInteractionEnabled = true
        buttonOptions.showsMenuAsPrimaryAction = true
        self.addSubview(buttonOptions)
    }
    
    func setupLabelRestaurant(){
        labelRestaurant = UILabel()
        labelRestaurant.font = UIFont.boldSystemFont(ofSize: 18)
        labelRestaurant.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelRestaurant)
    }
    
    func setupLabelCuisine(){
        labelCuisine = UILabel()
        labelCuisine.font = UIFont.boldSystemFont(ofSize: 16)
        labelCuisine.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelCuisine)
    }
    
    func setupLabelPeople(){
        labelPeople = UILabel()
        labelPeople.font = UIFont.boldSystemFont(ofSize: 16)
        labelPeople.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelPeople)
    }
    
    func setupLabelTime(){
        labelTime = UILabel()
        labelTime.font = UIFont.boldSystemFont(ofSize: 16)
        labelTime.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelTime)
    }
    
    func setupLabelLocation(){
        labelLocation = UILabel()
        labelLocation.font = UIFont.boldSystemFont(ofSize: 16)
        labelLocation.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelLocation)
    }
    
    func setupLabelPostedBy(){
        labelPostedBy = UILabel()
        labelPostedBy.font = UIFont.boldSystemFont(ofSize: 16)
        labelPostedBy.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelPostedBy)
    }
    
    func setupLabelPostedTime(){
        labelPostedTime = UILabel()
        labelPostedTime.font = UIFont.boldSystemFont(ofSize: 16)
        labelPostedTime.translatesAutoresizingMaskIntoConstraints = false
        wrapperCellView.addSubview(labelPostedTime)
    }
    
    func initConstraints(){
        NSLayoutConstraint.activate([
            wrapperCellView.topAnchor.constraint(equalTo: self.topAnchor,constant: 4),
            wrapperCellView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            wrapperCellView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            wrapperCellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            buttonOptions.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            buttonOptions.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            buttonOptions.widthAnchor.constraint(equalToConstant: 30),
            buttonOptions.heightAnchor.constraint(equalToConstant: 30),
            
            labelRestaurant.topAnchor.constraint(equalTo: wrapperCellView.topAnchor, constant: 8),
            labelRestaurant.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            labelRestaurant.heightAnchor.constraint(equalToConstant: 28),
            
            
            labelCuisine.topAnchor.constraint(equalTo: labelRestaurant.bottomAnchor, constant: 16),
            labelCuisine.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            labelCuisine.heightAnchor.constraint(equalToConstant: 20),
            
            labelPeople.topAnchor.constraint(equalTo: labelCuisine.bottomAnchor, constant: 8),
            labelPeople.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            labelPeople.heightAnchor.constraint(equalToConstant: 20),
            
            labelTime.topAnchor.constraint(equalTo: labelPeople.bottomAnchor, constant: 8),
            labelTime.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            labelTime.heightAnchor.constraint(equalToConstant: 20),
            
            labelLocation.topAnchor.constraint(equalTo: labelTime.bottomAnchor, constant: 8),
            labelLocation.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            labelLocation.heightAnchor.constraint(equalToConstant: 20),
            
            labelPostedBy.topAnchor.constraint(equalTo: labelLocation.bottomAnchor, constant: 16),
            labelPostedBy.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            labelPostedBy.heightAnchor.constraint(equalToConstant: 20),

            labelPostedTime.topAnchor.constraint(equalTo: labelPostedBy.bottomAnchor, constant: 8),
            labelPostedTime.leadingAnchor.constraint(equalTo: wrapperCellView.leadingAnchor, constant: 10),
            labelPostedTime.heightAnchor.constraint(equalToConstant: 20),

            
            wrapperCellView.heightAnchor.constraint(equalToConstant: 228)
            
        ])
        
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
