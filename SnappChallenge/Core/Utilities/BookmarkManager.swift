//
//  BookmarkManager.swift
//  SnappChallenge
//
//  Created by tanaz on 29/04/1403 AP.
//

import Foundation

/// Manages the bookmarking of launches using `UserDefaults`.
/// This class provides methods to add, remove, and check bookmarks.
class BookmarkManager {

    /// Shared singleton instance of `BookmarkManager`.
    static let shared = BookmarkManager()

    /// Key used to store bookmarks in `UserDefaults`.
    private let bookmarkKey = "bookmarkedLaunches"

    /// `UserDefaults` instance for storing and retrieving bookmarks.
    private let userDefaults = UserDefaults.standard

    /// Private initializer to enforce singleton usage.
    private init() {}

    /// Adds a launch to the bookmarks.
    /// - Parameter launch: The `Launch` object to be bookmarked.
    func bookmark(launch: Launch) {
        var bookmarks = getBookmarks()
        bookmarks.append(launch.flightNumber)
        userDefaults.set(bookmarks, forKey: bookmarkKey)
    }

    /// Removes a launch from the bookmarks.
    /// - Parameter launch: The `Launch` object to be removed from bookmarks.
    func removeBookmark(launch: Launch) {
        var bookmarks = getBookmarks()
        bookmarks.removeAll { $0 == launch.flightNumber }
        userDefaults.set(bookmarks, forKey: bookmarkKey)
    }

    /// Checks if a launch is bookmarked.
    /// - Parameter launch: The `Launch` object to check for bookmarking.
    /// - Returns: `true` if the launch is bookmarked, `false` otherwise.
    func isBookmarked(launch: Launch) -> Bool {
        return getBookmarks().contains(launch.flightNumber)
    }

    /// Retrieves the list of bookmarked flight numbers.
    /// - Returns: An array of flight numbers that are bookmarked.
    private func getBookmarks() -> [Int] {
        return userDefaults.array(forKey: bookmarkKey) as? [Int] ?? []
    }
}
