//
//  NetworkService.swift
//  SnappChallenge
//
//  Created by tanaz on 29/04/1403 AP.
//

import Foundation
import UIKit

/// Enumeration representing different types of network errors.
enum NetworkError: Error {
    case badURL
    case requestFailed
    case unknown
    case decodingError(Error)
}

/// A singleton class responsible for managing network requests.
///
/// Provides a generic method for making network requests and handling responses.
class NetworkService {

    /// The shared singleton instance of `NetworkService`.
    static let shared = NetworkService()

    private init() {}

    /// Performs a network request based on the provided `APIRequest` and handles the response.
    ///
    /// - Parameters:
    ///   - apiRequest: An object conforming to the `APIRequest` protocol that defines the request details.
    ///   - completion: A closure to be executed once the request completes. The closure contains a `Result` type with either a successful decoded response or a `NetworkError`.
    func request<T: Decodable>(_ apiRequest: APIRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {

        // Construct the full URL from baseURL and endpoint path
        guard let url = URL(string: APIConstants.baseURL + apiRequest.path) else {
            completion(.failure(.badURL))
            return
        }

        // Create and configure the URLRequest object
        var request = URLRequest(url: url)
        request.httpMethod = apiRequest.method

        // Set HTTP headers if provided
        if let headers = apiRequest.headers {
            headers.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        // Set the HTTP body if provided
        request.httpBody = apiRequest.body

        // Perform the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                // Log the error and return failure
                self.log(error: error)
                completion(.failure(.requestFailed))
                return
            }

            // Check that the response is an HTTP URL response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknown))
                return
            }

            // Ensure the response status code is in the 2xx range
            guard (200...299).contains(httpResponse.statusCode) else {
                self.log(response: httpResponse)
                completion(.failure(.requestFailed))
                return
            }

            // Ensure data is not nil
            guard let data = data else {
                completion(.failure(.unknown))
                return
            }

            // Attempt to decode the data into the expected type
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch let decodingError {
                // Log the decoding error and return failure
                self.log(error: decodingError)
                completion(.failure(.decodingError(decodingError)))
            }
        }.resume()
    }

    /// Logs an error that occurred during a network request.
    ///
    /// - Parameter error: The error to be logged.
    private func log(error: Error) {
        // Implement your logging logic here
        print("Network error: \(error.localizedDescription)")
    }

    /// Logs an HTTP response that was not successful.
    ///
    /// - Parameter response: The HTTP URL response to be logged.
    private func log(response: HTTPURLResponse) {
        // Implement your logging logic here
        print("HTTP error: \(response.statusCode)")
    }
}
