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
    
    /// Wrap entire function onto the MainActor thread
    @MainActor
    func fetchUsers() async {
        // Setup the APIService
        let apiService = APIService(urlString: "https://jsonplaceholder.typicode.com/users")
        
        // Toggle when loading
        isLoading.toggle()
        
        // Makes isLoading false, once this function exits
        defer {
            isLoading.toggle()
        }
        // MARK: Download the Users
        do {
            users = try await apiService.getJSON()
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
            self.users = User.mockUsers
        }
    }
}
