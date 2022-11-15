//
//  APIService.swift
//  iOS Concurrency
//
//  Created by Leone on 11/13/22.
//

import Foundation

/// Interacts with the API from any of our views
struct APIService {
    let urlString: String
    
    /// Takes a completion handler with an array of users as the argument. This will only execute once the code finishes/ we get a response back from the API.
    /// Because we do not know, when the data will be returned, we need to allow this completionHandler to escape the scope of this function.
    /// The Result type allows us to pass the correct data, or a failure with the response information.
    /// The method only works for Decodable types, and can represent the User or Post model.
    /// dateDecodingStrategy will also accept special tyes of ways to decode the dates of JSON
    func getJSON<T: Decodable>(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                                completion: @escaping (Result<T, APIError>) -> Void) {
        guard
            // If it does not successfully create a url object from the URL string, then return
            let url = URL(string: urlString)
        else {
            completion(.failure(.invalidUrl))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse, // Make sure it is a valid HTTPURLResponse
                httpResponse.statusCode == 200 // Ensure it has a HTTP 200 status code
            else {
                // Return the specialized case with the bad URL
                completion(.failure(.invalidResponseStatus))
                // If it does not have the conditions above, then return
                return
            }
            
            // Ensure there is no error
            guard
                error == nil
            else {
                completion(.failure(.dataTaskError))
                // If error does not equal nil, then return
                return
            }
            
            // Ensure that data was successfully returned
            guard
                let data = data
            else { // Else return
                // Pass in a corrupt data task error
                completion(.failure(.corruptData))
                return
            }
            
            // Try to decode the data
            let decoder = JSONDecoder()
            // Assign the special date/ key coding arguments to the decoder
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            
            do {
                // Try to decode the JSON array of users as an array of our User struct
                let decodedData = try decoder.decode(T.self, from: data)
                // Pass the array of users as an argument to the completion handler for the successful result
                completion(.success(decodedData))
            }
            catch {
                // Handles a decoding error
                completion(.failure(.decodingError))
            }
            
        }
        .resume() // Initializes the dataTask via the URLSession singleton
    }
}


/// Custom error message conforming to the Error protocol, which handles any of the error cases for our getUsers method.
enum APIError: Error {
    case invalidUrl
    case invalidResponseStatus
    case dataTaskError // Handles, when it failed to launch the data task
    case corruptData // If the response had bad data
    case decodingError // If our model did not conform to the JSON properly
}
