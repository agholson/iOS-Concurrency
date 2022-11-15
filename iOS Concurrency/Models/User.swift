//
//  User.swift
//  iOS Concurrency
//
//  Created by Leone on 11/12/22.
//

import Foundation

// https://jsonplaceholder.typicode.com

/// From the User model here: https://jsonplaceholder.typicode.com/users
/// Because we only read the properties, we can declare them as let constants
/// The Codable protocol allows us to transform this property directly from JSON
/// The Identifiable protocol allows the user to be unique based upon the ID property 
struct User: Codable, Identifiable {
    /*
     "id": 1,
        "name": "Leanne Graham",
        "username": "Bret",
        "email": "Sincere@april.biz",
     */
    let id: Int
    let name: String
    let username: String
    let email: String
}
