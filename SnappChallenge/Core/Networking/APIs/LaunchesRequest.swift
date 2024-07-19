//
//  LaunchesRequest.swift
//  SnappChallenge
//
//  Created by tanaz on 29/04/1403 AP.
//

import Foundation

/// A struct representing a request for fetching launches from the SpaceX API.
///
/// Conforms to the `APIRequest` protocol, which defines the required properties for constructing an API request.
struct LaunchesRequest: APIRequest {

    // MARK: - Properties

    /// The path of the API endpoint for this request. The endpoint is appended to the base URL defined in the APIRequest protocol.
    ///
    /// - Returns: A string representing the path to the endpoint.
    var path: String {
        return "launches/query"
    }

    /// The HTTP method used for the request.
    ///
    /// - Returns: A string representing the HTTP method (e.g., "POST").
    var method: String {
        return "POST"
    }

    /// The HTTP body for the request, encoded as JSON.
    ///
    /// - Returns: Optional `Data` object containing the JSON-encoded request body. The request body includes pagination and sorting options.
    var body: Data? {
        let requestBody = LaunchRequestBody(
            query: LaunchQuery(upcoming: false),
            options: LaunchOptions(
                limit: 50,
                page: page,
                sort: ["flight_number": "desc"]
            )
        )
        return try? JSONEncoder().encode(requestBody)
    }

    /// The page number used for pagination.
    ///
    /// - Note: This property is used to specify which page of results should be fetched from the API.
    private let page: Int

    /// Initializes a new instance of `LaunchesRequest`.
    ///
    /// - Parameter page: The page number for pagination.
    /// - Returns: An instance of `LaunchesRequest` configured with the specified page number.
    init(page: Int) {
        self.page = page
    }
}
