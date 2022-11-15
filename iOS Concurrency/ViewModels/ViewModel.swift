//
//  ViewModel.swift
//  iOS Concurrency
//
//  Created by Leone on 11/13/22.
//

import Foundation

class ViewModel: ObservableObject {
    // Initialize the users as an empty list of users
    @Published var users: [User] = []
    
    @Published var posts: [Post] = []
    
}
