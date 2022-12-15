//
//  UsersAndPosts.swift
//  iOS Concurrency
//
//  Created by Leone on 11/26/22.
//

import Foundation

struct UsersAndPosts: Identifiable {
    var id = UUID()
    
    let user: User
    let posts: [Post]
    var numberOfPosts: Int {
        return posts.count
    }
}
