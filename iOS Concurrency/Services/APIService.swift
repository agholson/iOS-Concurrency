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
    
    /// T: Decodable can be any type of decodable, or JSON data returned by the API.
    /// Throws the error to the code above it
    func getJSON<T: Decodable>(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                               keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) async throws -> T {
        guard
            let url = URL(string: urlString)
        else {
            // Throw the custom invalid URL error here
            throw APIError.invalidUrl
        }
        do {
            // First try, then await response, and assign returned tuple to separate variables
            let (data, response) = try await URLSession.shared.data(from: url)
            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 // Ensure it is a 200 HTTP status
            // Else if there is an error, throw that above
            else{
                throw APIError.invalidResponseStatus
            }
            
            // MARK: Process the returned JSON
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw APIError.decodingError(error.localizedDescription)
            }
            
        } catch  {
            // Passes the error message that was thrown
            throw APIError.dataTaskError(error.localizedDescription)
        }
                 
    }
    
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
                // Safely unwrap, because already ensured it is not nil
                completion(.failure(.dataTaskError(error!.localizedDescription)))
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
                completion(.failure(.decodingError(error.localizedDescription)))
            }
            
        }
        .resume() // Initializes the dataTask via the URLSession singleton
    }
}


/// Custom error message conforming to the Error protocol, which handles any of the error cases for our getUsers method.
enum APIError: Error, LocalizedError {
    case invalidUrl
    case invalidResponseStatus
    case dataTaskError(String) // Handles, when it failed to launch the data task
    case corruptData // If the response had bad data
    case decodingError(String) // If our model did not conform to the JSON properly
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            // Used, because it does not have an associated value already, comment used to tell translator how to translate this into another language
            return NSLocalizedString("The endpoint URL is invalid.", comment: "")
        case .invalidResponseStatus:
            return NSLocalizedString("The API failed to deliver a proper response.", comment: "")
        case .dataTaskError(let string):
            // Handles the error passed in from the above catch block
            return string
        case .corruptData:
            return NSLocalizedString("The data provided appears corrupted.", comment: "")
        case .decodingError(let string):
            return string
        }
    }
}
