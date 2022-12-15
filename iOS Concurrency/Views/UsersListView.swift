//
//  UsersList.swift
//  iOS Concurrency
//
//  Created by Leone on 11/12/22.
//

import SwiftUI

struct UsersListView: View {
    // Initialize a state object for the users list view model
    #warning("Remove preview below prior to shipping or set to false")
//    @StateObject var vm = UsersListViewModel(forPreview: false)
    @StateObject var vm = UsersListViewModel(forPreview: false)
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.usersAndPosts) { userAndPost in
                    NavigationLink {
                        PostsListView(posts: userAndPost.posts )
                    } label: {
                        VStack(alignment: .leading) {
                            HStack {
                                // Display user name
                                Text(userAndPost.user.name)
                                    .font(.title)
                                
                                // Display number of user posts
                                Text("(\(userAndPost.numberOfPosts))")
                            }
                            
                            Text(userAndPost.user.email)
                                .font(.body)
                        }
                    }
                }
            }
            .overlay(content: {
                // Check if the screen is loading
                if vm.isLoading {
                    // If it is, then display this
                    ProgressView("Loading users")
                }
            })
            .alert("Application Error", isPresented: $vm.showAlert, actions: {
                // Let's user press okay button to 
                Button("Okay") {}
            }, message: {
                // Only show error message if not nil
                if let errorMessage = vm.errorMessage {
                    Text(errorMessage)
                }
            })
            .navigationTitle("Users")
            .listStyle(.plain) // New way to formulate style
            .task { // As soon as this appear run the code below asynchronously
                await vm.fetchUsers()
            }
        }
    }
}

struct UsersList_Previews: PreviewProvider {
    static var previews: some View {
        // Can use this to initialize with empty fake users list
//        UsersListView.init(vm: UsersListViewModel(forPreview: true))
        UsersListView()

    }
}
