//
//  Untitled.swift
//  EATAR
//
//  Created by kangweijia on 2024/11/26.
//

// Helper class to manage post queries

import Foundation
import FirebaseFirestore

class PostManager {
    private let db = Firestore.firestore()
    
    // Fetch posts created by user
    func fetchUserCreatedPosts(userEmail: String, completion: @escaping ([DiningPost]?, Error?) -> Void) {
        db.collection("posts")
            .whereField("creatorId", isEqualTo: userEmail)
            .order(by: "dateTime", descending: false)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(nil, error)
                    return
                }
                
                let posts = snapshot?.documents.compactMap { DiningPost.fromFirestore($0) }
                completion(posts, nil)
            }
    }
    
    // Fetch posts user has joined
    func fetchUserJoinedPosts(userEmail: String, timeStatus: PostTimeStatus,
                            completion: @escaping ([DiningPost]?, Error?) -> Void) {
        let query = db.collection("posts")
            .whereField("participants", arrayContains: userEmail)
        
        // Add time filter based on current date
        let now = Timestamp(date: Date())
        
        switch timeStatus {
        case .upcoming:
            query.whereField("dateTime", isGreaterThan: now)
                .order(by: "dateTime", descending: false)
        case .past:
            query.whereField("dateTime", isLessThan: now)
                .order(by: "dateTime", descending: true)
        }
        
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            let posts = snapshot?.documents.compactMap { DiningPost.fromFirestore($0) }
            completion(posts, nil)
        }
    }
    
    // Add user to post participants
    func joinPost(postId: String, userEmail: String, completion: @escaping (Error?) -> Void) {
        let postRef = db.collection("posts").document(postId)
        
        db.runTransaction({ (transaction, errorPointer) -> Any? in
            let postDocument: DocumentSnapshot
            do {
                try postDocument = transaction.getDocument(postRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                return nil
            }
            
            guard let post = postDocument.data(),
                  let currentPeople = post["currentPeople"] as? Int,
                  let maxPeople = post["maxPeople"] as? Int,
                  var participants = post["participants"] as? [String] else {
                return nil
            }
            
            // Check if there's still space
            guard currentPeople < maxPeople else {
                let error = NSError(domain: "PostError", code: -1,
                                  userInfo: [NSLocalizedDescriptionKey: "Post is full"])
                errorPointer?.pointee = error
                return nil
            }
            
            // Add participant and increment count
            participants.append(userEmail)
            transaction.updateData([
                "participants": participants,
                "currentPeople": currentPeople + 1
            ], forDocument: postRef)
            
            return nil
        }, completion: { (_, error) in
            completion(error)
        })
    }
}
