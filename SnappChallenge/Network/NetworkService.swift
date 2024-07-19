//
//  NetworkService.swift
//  SnappChallenge
//
//  Created by tanaz on 29/04/1403 AP.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case badURL
    case requestFailed
    case unknown
    case decodingError(Error)
}

class NetworkService {
    static let shared = NetworkService()

    private init() {}

    func request<T: Decodable>(_ apiRequest: APIRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = URL(string: apiRequest.baseURL + apiRequest.path) else {
            completion(.failure(.badURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = apiRequest.method
        if let headers = apiRequest.headers {
            headers.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        request.httpBody = apiRequest.body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                self.log(error: error)
                completion(.failure(.requestFailed))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.unknown))
                return
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                self.log(response: httpResponse)
                completion(.failure(.requestFailed))
                return
            }

            guard let data = data else {
                completion(.failure(.unknown))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch let decodingError {
                self.log(error: decodingError)
                completion(.failure(.decodingError(decodingError)))
            }
        }.resume()
    }

  func loadImage(from url: URL, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
          URLSession.shared.dataTask(with: url) { data, response, error in
              if let error = error {
                  self.log(error: error)
                  completion(.failure(.requestFailed))
                  return
              }

              guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                  if let httpResponse = response as? HTTPURLResponse {
                      self.log(response: httpResponse)
                  }
                  completion(.failure(.requestFailed))
                  return
              }

              guard let data = data, let image = UIImage(data: data) else {
                  completion(.failure(.unknown))
                  return
              }

              completion(.success(image))
          }.resume()
      }

    private func log(error: Error) {
        // Implement your logging here
        print("Network error: \(error.localizedDescription)")
    }

    private func log(response: HTTPURLResponse) {
        // Implement your logging here
        print("HTTP error: \(response.statusCode)")
    }
}
