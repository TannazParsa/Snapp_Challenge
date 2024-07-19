//
//  APIRequest.swift
//  SnappChallenge
//
//  Created by tanaz on 29/04/1403 AP.
//

import Foundation
protocol APIRequest {
    var baseURL: String { get }
    var path: String { get }
    var method: String { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

extension APIRequest {
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    var body: Data? {
        return nil
    }
}
