//
//  MockData.swift
//  iOS Concurrency
//
//  Created by Leone on 11/14/22.
//
// Mocks data used in Previews

import Foundation


/// Creates mock data for the User class for our views
extension User {
    // Create a computed property, which returns a list of users from the users.json file
    static var mockUsers: [User] {
        Bundle.main.decode([User].self, from: "users.json")
    }
    
    // Return a single user, or the first one in the mockUsers list
    static var mockSingleUser: User {
        Self.mockUsers[0]
    }
}

extension Post {
    // Gets all of the mock posts from the JSON data
    static var mockPosts: [Post] {
        // Decodes the JSON in the posts.json file into the Decodable Post class
        Bundle.main.decode([Post].self, from: "posts.json")
    }
    
    static var mockSinglePost: Post {
        // Returns the first post in the mockPosts list
        Self.mockPosts[0]
    }
    
    // Only returns the posts belonging to a single user
    static var mockPostsBySingleUser: [Post] {
        // Filters to return the posts that match the user ID 1
        Self.mockPosts.filter{ $0.userId == 1}
    }
}
