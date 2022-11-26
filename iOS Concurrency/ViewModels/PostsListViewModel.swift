//
//  PostsListViewModel.swift
//  iOS Concurrency
//
//  Created by Leone on 11/15/22.
//

import Foundation

class PostsListViewModel: ObservableObject {
    @Published var posts: [Post] = []
    // Make optional parameter required to display specific posts
    var userId: Int?
    
    // Tracks whether/ not the posts have been fetched
    @Published var isLoading = false
    
    @Published var showAlert = false
    @Published var errorMessage: String?
    
    /// Fetch the posts for a given user ID. If the user ID is not set, then do nothing
    @MainActor
    func fetchPosts() async {
        // Only process this, if userId is not nil
        if let userId = userId {
            
            // Toggle the isLoading to true
            self.isLoading = true
            
            defer {
                // Turn off the loading, once it finishes
                isLoading.toggle()
            }
            
            let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users/\(userId)/posts")
            
            do {
                posts = try await apiService.getJSON()
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription + "\n Please contact the developer with this error, and the steps to reproduce it."
            }
        }
    }
}

extension PostsListViewModel {
    convenience init(forPreview: Bool) {
        self.init()
        
        // If the preview is active
        if forPreview {
            // Then set the posts equal to the mock posts for a single user
            self.posts = Post.mockPostsBySingleUser
        }
    }
}
