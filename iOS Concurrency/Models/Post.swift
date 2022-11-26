//
//  Post.swift
//  iOS Concurrency
//
//  Created by Leone on 11/12/22.
//

import Foundation

/// From: https://jsonplaceholder.typicode.com/posts returns all posts
/// Meanwhile, this route returns all posts by a single user: https://jsonplaceholder.typicode.com/users/1/posts
/// Expects this type of response from the JSON API:
/// {
//"userId": 1,
//"id": 1,
//"title": "sunt aut facere repellat provident occaecati excepturi optio reprehenderit",
//"body": "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto"
//},
struct Post: Identifiable, Codable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
