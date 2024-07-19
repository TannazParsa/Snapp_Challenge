//
//  BookmarkManager.swift
//  SnappChallenge
//
//  Created by tanaz on 29/04/1403 AP.
//

import Foundation
class BookmarkManager {
    static let shared = BookmarkManager()
    private let userDefaults = UserDefaults.standard
    private let bookmarkKey = "bookmarkedLaunches"

    func bookmark(launch: Launch) {
        var bookmarks = getBookmarks()
        bookmarks.append(launch.flightNumber)
        userDefaults.set(bookmarks, forKey: bookmarkKey)
    }

    func removeBookmark(launch: Launch) {
        var bookmarks = getBookmarks()
        bookmarks.removeAll { $0 == launch.flightNumber }
        userDefaults.set(bookmarks, forKey: bookmarkKey)
    }

    func isBookmarked(launch: Launch) -> Bool {
        return getBookmarks().contains(launch.flightNumber)
    }

    private func getBookmarks() -> [Int] {
        return userDefaults.array(forKey: bookmarkKey) as? [Int] ?? []
    }
}
