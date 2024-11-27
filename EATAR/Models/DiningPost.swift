//
//  Untitled.swift
//  EATAR
//
//  Created by kangweijia on 2024/11/26.
//

import Foundation
import FirebaseFirestore

// Enum to help categorize post status from user's perspective
enum PostTimeStatus {
    case upcoming
    case past
}

struct DiningPost {
    let id: String
    let restaurantName: String
    let cuisine: String
    let maxPeople: Int
    var currentPeople: Int
    let dateTime: Date
    let location: String
    let zipCode: String
    let note: String
    let creatorId: String
    var participants: [String]
    var status: PostStatus
    let createdAt: Date
    
    enum PostStatus: String {
        case active = "active"
        case completed = "completed"
        case cancelled = "cancelled"
    }
    
    // Helper computed property to determine if post is upcoming or past
    var timeStatus: PostTimeStatus {
        return dateTime > Date() ? .upcoming : .past
    }
    
    // Convenience initializer for creating new posts
    init(restaurantName: String, cuisine: String, maxPeople: Int, dateTime: Date,
         location: String, zipCode: String, note: String, creatorId: String) {
        self.id = UUID().uuidString
        self.restaurantName = restaurantName
        self.cuisine = cuisine
        self.maxPeople = maxPeople
        self.currentPeople = 1  // Creator counts as first participant
        self.dateTime = dateTime
        self.location = location
        self.zipCode = zipCode
        self.note = note
        self.creatorId = creatorId
        self.participants = [creatorId]  // Creator is first participant
        self.status = .active
        self.createdAt = Date()
    }
    
    // Main initializer
    init(id: String, restaurantName: String, cuisine: String, maxPeople: Int,
         currentPeople: Int, dateTime: Date, location: String, zipCode: String, note: String,
         creatorId: String, participants: [String], status: PostStatus, createdAt: Date) {
        self.id = id
        self.restaurantName = restaurantName
        self.cuisine = cuisine
        self.maxPeople = maxPeople
        self.currentPeople = currentPeople
        self.dateTime = dateTime
        self.location = location
        self.zipCode = zipCode
        self.note = note
        self.creatorId = creatorId
        self.participants = participants
        self.status = status
        self.createdAt = createdAt
    }
    
    // Convert Firestore Document to DiningPost
    static func fromFirestore(_ document: QueryDocumentSnapshot) -> DiningPost? {
        let data = document.data()
        
        guard let restaurantName = data["restaurantName"] as? String,
              let cuisine = data["cuisine"] as? String,
              let maxPeople = data["maxPeople"] as? Int,
              let currentPeople = data["currentPeople"] as? Int,
              let dateTime = (data["dateTime"] as? Timestamp)?.dateValue(),
              let location = data["location"] as? String,
              let zipCode = data["zipCode"] as? String,
              let note = data["note"] as? String,
              let creatorId = data["creatorId"] as? String,
              let participants = data["participants"] as? [String],
              let statusRaw = data["status"] as? String,
              let createdAt = (data["createdAt"] as? Timestamp)?.dateValue(),
              let status = PostStatus(rawValue: statusRaw) else {
            return nil
        }
        
        return DiningPost(
            id: document.documentID,
            restaurantName: restaurantName,
            cuisine: cuisine,
            maxPeople: maxPeople,
            currentPeople: currentPeople,
            dateTime: dateTime,
            location: location,
            zipCode: zipCode,
            note: note,
            creatorId: creatorId,
            participants: participants,
            status: status,
            createdAt: createdAt
        )
    }
    
    func toFirestore() -> [String: Any] {
        return [
            "restaurantName": restaurantName,
            "cuisine": cuisine,
            "maxPeople": maxPeople,
            "currentPeople": currentPeople,
            "dateTime": Timestamp(date: dateTime),
            "location": location,
            "zipCode": zipCode,
            "note": note,
            "creatorId": creatorId,
            "participants": participants,
            "status": status.rawValue,
            "createdAt": Timestamp(date: createdAt)
        ]
    }
}

