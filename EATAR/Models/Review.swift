//
//  Untitled.swift
//  EATAR
//
//  Created by kangweijia on 2024/11/26.
//

import Foundation
import FirebaseFirestore

struct Review {
    let id: String
    let postId: String
    let reviewerId: String
    let restaurantName: String
    let foodRating: Int
    let serviceRating: Int
    let environmentRating: Int
    let reviewText: String
    let photos: [String]
    let createdAt: Date
    
    // Convenience initializer for creating new reviews
    init(postId: String, reviewerId: String, restaurantName: String,
         foodRating: Int, serviceRating: Int, environmentRating: Int,
         reviewText: String, photos: [String] = []) {
        self.id = UUID().uuidString
        self.postId = postId
        self.reviewerId = reviewerId
        self.restaurantName = restaurantName
        self.foodRating = foodRating
        self.serviceRating = serviceRating
        self.environmentRating = environmentRating
        self.reviewText = reviewText
        self.photos = photos
        self.createdAt = Date()
    }
    
    // Main initializer with all properties
    init(id: String, postId: String, reviewerId: String, restaurantName: String,
         foodRating: Int, serviceRating: Int, environmentRating: Int,
         reviewText: String, photos: [String], createdAt: Date) {
        self.id = id
        self.postId = postId
        self.reviewerId = reviewerId
        self.restaurantName = restaurantName
        self.foodRating = foodRating
        self.serviceRating = serviceRating
        self.environmentRating = environmentRating
        self.reviewText = reviewText
        self.photos = photos
        self.createdAt = createdAt
    }
    
    // Computed property to get average rating
    var averageRating: Double {
        return Double(foodRating + serviceRating + environmentRating) / 3.0
    }
    
    // Convert Firestore Document to Review
    static func fromFirestore(_ document: QueryDocumentSnapshot) -> Review? {
        let data = document.data()
        
        guard let postId = data["postId"] as? String,
              let reviewerId = data["reviewerId"] as? String,
              let restaurantName = data["restaurantName"] as? String,
              let foodRating = data["foodRating"] as? Int,
              let serviceRating = data["serviceRating"] as? Int,
              let environmentRating = data["environmentRating"] as? Int,
              let reviewText = data["reviewText"] as? String,
              let photos = data["photos"] as? [String],
              let createdAt = (data["createdAt"] as? Timestamp)?.dateValue() else {
            return nil
        }
        
        return Review(
            id: document.documentID,
            postId: postId,
            reviewerId: reviewerId,
            restaurantName: restaurantName,
            foodRating: foodRating,
            serviceRating: serviceRating,
            environmentRating: environmentRating,
            reviewText: reviewText,
            photos: photos,
            createdAt: createdAt
        )
    }
    
    // Convert Review to Firestore Document
    func toFirestore() -> [String: Any] {
        return [
            "postId": postId,
            "reviewerId": reviewerId,
            "restaurantName": restaurantName,
            "foodRating": foodRating,
            "serviceRating": serviceRating,
            "environmentRating": environmentRating,
            "reviewText": reviewText,
            "photos": photos,
            "createdAt": Timestamp(date: createdAt)
        ]
    }
    
    // Validate rating values
    static func isValidRating(_ rating: Int) -> Bool {
        return rating >= 1 && rating <= 5
    }
}

// Extension to add validation methods
extension Review {
    // Validate all fields of a review
    func isValid() -> Bool {
        // Check if ratings are within valid range
        guard Review.isValidRating(foodRating),
              Review.isValidRating(serviceRating),
              Review.isValidRating(environmentRating) else {
            return false
        }
        
        // Check if required text fields are not empty
        guard !restaurantName.isEmpty,
              !reviewText.isEmpty else {
            return false
        }
        
        // Check if references exist
        guard !postId.isEmpty,
              !reviewerId.isEmpty else {
            return false
        }
        
        return true
    }
}
