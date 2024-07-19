//
//  LaunchQuery.swift
//  SnappChallenge
//
//  Created by tanaz on 29/04/1403 AP.
//

import Foundation
struct LaunchQuery: Codable {
    let upcoming: Bool
}

struct LaunchOptions: Codable {
    let limit: Int
    let page: Int
    let sort: [String: String]
}

struct LaunchRequestBody: Codable {
    let query: LaunchQuery
    let options: LaunchOptions
}
