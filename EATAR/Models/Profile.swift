//
//  Profile.swift
//  EATAR
//
//  Created by NaN Wang on 12/3/24.
//

import FirebaseFirestore

struct Profile {
    let username: String?
    let gender: Gender?
    let location: String?
    let cuisinePreference: String?
    let favoriteRestaurant: String?
    let bio: String?
    let hasProfile: Bool?

    enum Gender: String {
        case man = "man"
        case woman = "woman"
        case other = "other"
        case notToSay = "prefer not to say"
    }

    // Initializer for creating Profile directly
    init(username: String?, gender: Gender?, location: String?, cuisinePreference: String?, favoriteRestaurant: String?, bio: String?, hasProfile: Bool?) {
        self.username = username
        self.gender = gender
        self.location = location
        self.cuisinePreference = cuisinePreference
        self.favoriteRestaurant = favoriteRestaurant
        self.bio = bio
        self.hasProfile = hasProfile
    }

    // Initializer for creating Profile from Firestore data
    init?(from data: [String: Any]) {
        self.username = data["username"] as? String
        if let genderString = data["gender"] as? String {
            self.gender = Gender(rawValue: genderString)
        } else {
            self.gender = nil
        }
        self.location = data["location"] as? String
        self.cuisinePreference = data["cuisinePreference"] as? String
        self.favoriteRestaurant = data["favoriteRestaurant"] as? String
        self.bio = data["bio"] as? String
        self.hasProfile = data["hasProfile"] as? Bool
    }

    func toFirestoreData() -> [String: Any] {
        return [
            "username": username ?? "",
            "gender": gender?.rawValue ?? "",
            "location": location ?? "",
            "cuisinePreference": cuisinePreference ?? "",
            "favoriteRestaurant": favoriteRestaurant ?? "",
            "bio": bio ?? "",
            "hasProfile": hasProfile ?? false
        ]
    }
}
