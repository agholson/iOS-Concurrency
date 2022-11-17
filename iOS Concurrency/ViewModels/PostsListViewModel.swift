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
    
    /// Fetch the posts for a given user ID. If the user ID is not set, then do nothing
    func fetchPosts() {
        // Only process this, if userId is not nil
        if let userId = userId {
            let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users/\(userId)/posts")
            
            apiService.getJSON {(result: Result<[Post], APIError>) in
                // set code here
                switch result {
                    // Assigns the returned value to the let posts
                case .success(let posts):
                    DispatchQueue.main.async {
                        self.posts = posts
                    }
                case .failure(let error):
                    print("Error fetching posts on line 29: \(error)")
                    
                }
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
