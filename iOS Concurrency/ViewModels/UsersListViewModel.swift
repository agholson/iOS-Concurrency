//
//  UsersListViewModel.swift
//  iOS Concurrency
//
//  Created by Leone on 11/14/22.
//

import Foundation

class UsersListViewModel: ObservableObject {
    // Single users property
    @Published var usersAndPosts: [UsersAndPosts] = []
    
    // Represents whether/ not something is loading
    @Published var isLoading = false
    
    // Determines whether/ not to show an error alert to the user
    @Published var showAlert = false
    // Variable that holds error message
    @Published var errorMessage: String?
    
    /// Wrap entire function onto the MainActor thread
    @MainActor
    func fetchUsers() async {
        // Setup the APIService
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        // Create an API service to get all the Posts
        let apiServicePosts = APIService(urlString: "https://jsonplaceholder.typicode.com/posts")
        
        // Toggle when loading
        isLoading.toggle()
        
        // Makes isLoading false, once this function exits
        defer {
            isLoading.toggle()
        }
        // MARK: Download the Users
        do {
            // Fetch all the users
            async let users: [User] = try await apiService.getJSON()
            
            // The fetch of the posts does not execute until all of the users are fetched
            async let posts: [Post] = try await apiServicePosts.getJSON()
            
            // Wait the returned data
            let (fetchedUsers, fetchedPosts) = await (try users, try posts)
                        
            // Determine all the posts for each of the users
            for user in fetchedUsers {
                // Gran only the posts associated with a single user
                let userPosts = fetchedPosts.filter {$0.userId == user.id}
                
                // Add a new element of UsersAndPosts to the usersAndPosts array
                usersAndPosts.append(UsersAndPosts(user: user, posts: userPosts))
            }
            
        } catch {
            // Set the showAlert variable to true to display an alert to the end users
            showAlert = true
            errorMessage = error.localizedDescription + "\n Please contact the developer with this error, and the steps to reproduce it."
        }
        
    }
}

/// Only use this in the preview
extension UsersListViewModel {
    convenience init(forPreview: Bool = false) {
        // Initialize the regular class
        self.init()
        
        // If preview is active, then set the users property equal to the mock users
        if forPreview {
            self.usersAndPosts = UsersAndPosts.mockUsersAndPosts
        }
    }
}
