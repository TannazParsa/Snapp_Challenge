//
//  APIRequest.swift
//  SnappChallenge
//
//  Created by tanaz on 29/04/1403 AP.
//

import Foundation

/// Protocol representing an API Request.
/// Conforming types must provide values for the `path` and `method` properties.
/// The `headers` and `body` properties have default implementations.
protocol APIRequest {
    /// The URL path for the API request.
    var path: String { get }

    /// The HTTP method for the API request (e.g., "GET", "POST").
    var method: String { get }

    /// The HTTP headers for the API request.
    /// The default implementation provides a `Content-Type` header with a value of `application/json`.
    var headers: [String: String]? { get }

    /// The HTTP body for the API request.
    /// The default implementation returns `nil`.
    var body: Data? { get }
}

extension APIRequest {
    /// Default headers implementation, providing a `Content-Type` header with a value of `application/json`.
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    /// Default body implementation, returning `nil`.
    var body: Data? {
        return nil
    }
}
