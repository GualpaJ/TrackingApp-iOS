//
//  User.swift
//  TrackingApp
//
//  Created by Tardes on 5/6/26.
//

struct User: Codable, Sendable {
    var id: String
    var username: String
    var firstName: String
    var lastName: String
    var gender: Int
    var birthday: Int64?
    var profileImageUrl: String?
    
    func fullName() -> String {
        return "\(firstName) \(lastName)"
    }
}
