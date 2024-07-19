//
//  LaunchDetailViewModel.swift
//  SnappChallenge
//
//  Created by tanaz on 30/04/1403 AP.
//

import Foundation
import UIKit

/// `LaunchDetailViewModel` is responsible for managing the data and state for the details of a specific SpaceX launch.
/// It provides the necessary data for the `LaunchDetailViewController` and handles bookmarking functionality.
class LaunchDetailViewModel {

    // MARK: - Properties

    private var launch: Launch
    var onBookmarkStatusChange: (() -> Void)?

    // MARK: - Initializer

    /// Initializes the view model with a `Launch` object.
    ///
    /// - Parameter launch: The `Launch` object containing the details of a specific launch.
    init(launch: Launch) {
        self.launch = launch
    }

    // MARK: - Computed Properties

    /// The name of the mission.
    var missionName: String {
        return launch.name
    }

    /// The flight number of the mission.
    var flightNumber: String {
        return "Flight \(launch.flightNumber)"
    }

    /// The details of the mission. If details are not available, a default message is returned.
    var missionDetails: String {
        return launch.details ?? "No details available"
    }

    /// The date of the mission in a localized string format.
    var missionDate: String {
        return launch.localDateString
    }

    /// The URL of the mission image, if available.
    var missionImageURL: String? {
        if let missionPatch = launch.links.patch?.large {
            return missionPatch
        }
        return nil
    }

    /// The URL of the Wikipedia page for the mission, if available.
    var wikipediaURL: URL? {
        if let wikipedia = launch.links.wikipedia {
            return URL(string: wikipedia)
        }
        return nil
    }

    /// A Boolean value indicating whether the mission is bookmarked.
    var isBookmarked: Bool {
        return BookmarkManager.shared.isBookmarked(launch: launch)
    }

    // MARK: - Methods

    /// Toggles the bookmark status of the mission.
    /// If the mission is currently bookmarked, it removes the bookmark; otherwise, it adds a bookmark.
    /// It also triggers the `onBookmarkStatusChange` closure to update the UI.
    func toggleBookmark() {
        if isBookmarked {
            BookmarkManager.shared.removeBookmark(launch: launch)
        } else {
            BookmarkManager.shared.bookmark(launch: launch)
        }
        onBookmarkStatusChange?()
    }
}
