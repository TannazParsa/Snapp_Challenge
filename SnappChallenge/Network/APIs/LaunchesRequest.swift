//
//  LaunchesRequest.swift
//  SnappChallenge
//
//  Created by tanaz on 29/04/1403 AP.
//

import Foundation
struct LaunchesRequest: APIRequest {
    var baseURL: String {
        return "https://api.spacexdata.com/v5/launches/query"
    }

    var path: String {
        return ""
    }

    var method: String {
        return "POST"
    }

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

    private let page: Int

    init(page: Int) {
        self.page = page
    }
}
