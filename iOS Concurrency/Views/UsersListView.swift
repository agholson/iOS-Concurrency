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
    @StateObject var vm = UsersListViewModel(forPreview: false)
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.users) { user in
                    NavigationLink {
                        PostsListView(userId: user.id)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.title)
                            
                            Text(user.email)
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
            .onAppear {
                // As soon as this appears, fetch the users to update the view
                vm.fetchUsers()
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
