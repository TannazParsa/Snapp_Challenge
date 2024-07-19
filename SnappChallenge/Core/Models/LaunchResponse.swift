//
//  LaunchResponse.swift
//  SnappChallenge
//
//  Created by tanaz on 29/04/1403 AP.
//

import Foundation
struct LaunchResponse: Codable {
    let docs: [Launch]
    let totalPages: Int
    let page: Int
}
