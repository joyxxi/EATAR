//
//  Experience.swift
//  EATAR
//
//  Created by Mohan Qi on 11/3/24.
//

import Foundation

struct Experience{
    var restaurant: String?
    var cuisine: String?
    var people: String?
    var time: String?
    var location: String?
    var postedBy: String?
    var postedTime: String?
    
    init(restaurant: String?=nil, cuisine: String?=nil, people: String?=nil, time: String?=nil, location: String?=nil, postedBy: String?=nil, postedTime: String?=nil) {
        self.restaurant = restaurant
        self.cuisine = cuisine
        self.people = people
        self.time = time
        self.location = location
        self.postedBy = postedBy
        self.postedTime = postedTime
    }
}
