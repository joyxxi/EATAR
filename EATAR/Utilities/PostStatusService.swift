//
//  PostStatusService.swift
//  EATAR
//
//  Created by Mohan Qi on 11/30/24.
//

import Foundation
import FirebaseFirestore

class PostStatusService {
    static let shared = PostStatusService() // Singleton instance
    
    private init() {} // Private initializer
    
    func checkAndUpdateCompletedPostsOnAppLaunch() {
        let database = Firestore.firestore()
        let currentDate = Date()
        
        database.collection("posts")
            .whereField("status", isEqualTo: DiningPost.PostStatus.active.rawValue)
            .whereField("dateTime", isLessThan: currentDate.addingTimeInterval(-1 * 60 * 60))
            .getDocuments { (snapshot, error) in
                guard let documents = snapshot?.documents else {
                    print("Error fetching posts to update: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                let batch = database.batch()
                
                for document in documents {
                    let postRef = database.collection("posts").document(document.documentID)
                    
                    batch.updateData([
                        "status": DiningPost.PostStatus.completed.rawValue,
                    ], forDocument: postRef)
                }
                
                batch.commit { error in
                    if let error = error {
                        print("Error updating post statuses: \(error.localizedDescription)")
                    } else {
                        print("Successfully updated \(documents.count) post statuses to completed")
                    }
                }
            }
    }
}
