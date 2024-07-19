//
//  Luanch.swift
//  SnappChallenge
//
//  Created by tanaz on 29/04/1403 AP.
//

import Foundation
struct Launch: Codable {
    let flightNumber: Int
    let name: String
    let links: Links
    let success: Bool?
    let details: String?
    let dateUTC: String

    struct Links: Codable {
        let patch: Patch?
        let wikipedia: String?
    }

    struct Patch: Codable {
        let small: String?
        let large: String?
    }

    enum CodingKeys: String, CodingKey {
        case flightNumber = "flight_number"
        case name
        case links
        case success
        case details
        case dateUTC = "date_utc"
    }

  var localDateString: String {
          // Create a date formatter for ISO8601
          let isoFormatter = ISO8601DateFormatter()
          isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

          // Convert the dateUTC string to Date
          guard let date = isoFormatter.date(from: dateUTC) else {
              return dateUTC
          }

          // Create a date formatter for the desired output format
          let formatter = DateFormatter()
          formatter.timeZone = TimeZone.current
          formatter.dateFormat = "yyyy-MM-dd HH:mm"

          // Convert Date to the desired string format
          return formatter.string(from: date)
      }
}
