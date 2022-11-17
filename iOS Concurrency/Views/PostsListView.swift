//
//  PostsListView.swift
//  iOS Concurrency
//
//  Created by Leone on 11/15/22.
//

import SwiftUI

struct PostsListView: View {
    
    @StateObject var vm = PostsListViewModel()
    var userId: Int?
    
    var body: some View {
        List {
            ForEach(vm.posts) { post in
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.headline)
                    Text(post.body)
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Posts") // Can change this, because we know we are in a Navigation View
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Set the passed-in userId to the view model
            vm.userId = userId
            // fetch the posts for the user
            vm.fetchPosts()
        }
    }
}

struct PostsListView_Previews: PreviewProvider {
    static var previews: some View {
        // Surround Preview in a NavigationView as it will appear in the app
        NavigationView {
            PostsListView(vm: PostsListViewModel(forPreview: true))
        }
    }
}
