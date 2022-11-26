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
    
    // Represents whether/ not something is loading
    @Published var isLoading = false
    
    // Determines whether/ not to show an error alert to the user
    @Published var showAlert = false
    // Variable that holds error message
    @Published var errorMessage: String?
    
    func fetchUsers() {
        // Setup the APIService
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        
        // Toggle when loading
        isLoading.toggle()
        
        // Call the API here
        apiService.getJSON { (result: Result<[User], APIError>) in // Tell it to return a Result of list of users and APIError for the error
            // Executes this code, once it has retrieved/ processed the data
            defer {
                // Turn the toggle to isLoading to false
                DispatchQueue.main.async {
                    self.isLoading.toggle()
                }
            }
            
            // Use a switch statement to handle the types of responses
            switch result {
            case .success(let users):
                // Re-enter the main thread to update the Published users in the view
                DispatchQueue.main.async {
                    self.users = users
                }
                // If the result object is a failure, then do this
            case .failure(let error):
                // Update with custom error message
                DispatchQueue.main.async {
                    self.showAlert = true
                    self.errorMessage = error.localizedDescription + "\n Please contact the developer with this error, and the steps to reproduce it."
                }
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
