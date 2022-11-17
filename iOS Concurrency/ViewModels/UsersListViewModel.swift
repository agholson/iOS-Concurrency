//
//  UsersListViewModel.swift
//  iOS Concurrency
//
//  Created by Leone on 11/14/22.
//

import Foundation

class UsersListViewModel: ObservableObject {
    // Single users property
    @Published var users: [User] = []
    
    func fetchUsers() {
        // Setup the APIService
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        
        // Call the API here
        apiService.getJSON { (result: Result<[User], APIError>) in // Tell it to return a Result of list of users and APIError for the error
            // Use a switch statement to handle the types of responses
            switch result {
            case .success(let users):
                // Re-enter the main thread to update the Published users in the view
                DispatchQueue.main.async {
                    self.users = users
                }
            // If the result object is a failure, then do this
            case .failure(let error):
                print("Error line 29 in UsersListViewModel: \(error)")
            }
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
            self.users = User.mockUsers
        }
    }
}
