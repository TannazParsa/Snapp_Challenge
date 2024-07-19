//
//  LaunchListViewModel.swift
//  SnappChallenge
//
//  Created by tanaz on 29/04/1403 AP.
//

import Foundation
import UIKit

/// `LaunchListViewModel` is responsible for managing the data and state for a list of SpaceX launches.
/// It handles fetching launches from a network service, pagination, and image loading.
class LaunchListViewModel {

    // MARK: - Properties

    private var launches: [Launch] = []
    private var currentPage: Int = 1
    private var isFetching: Bool = false
    private var hasMoreData: Bool = true

    // Closures for updating the view
    var onUpdate: (() -> Void)?
    var onError: ((NetworkError) -> Void)?
    var onImageLoad: ((IndexPath, UIImage?) -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    var onPaginationLoadingStateChange: ((Bool) -> Void)?

    // MARK: - Public Methods

    /// Fetches launches from the network. Handles both initial load and pagination.
    ///
    /// - Parameter isPagination: A Boolean indicating if the fetch is for pagination.
    func fetchLaunches(isPagination: Bool = false) {
        guard !isFetching && hasMoreData else { return }
        isFetching = true
        if isPagination {
            onPaginationLoadingStateChange?(true)
        } else {
            onLoadingStateChange?(true)
        }

        let request = LaunchesRequest(page: currentPage)
        NetworkService.shared.request(request) { [weak self] (result: Result<LaunchResponse, NetworkError>) in
            guard let self = self else { return }
            self.isFetching = false
            if isPagination {
                self.onPaginationLoadingStateChange?(false)
            } else {
                self.onLoadingStateChange?(false)
            }

            switch result {
            case .success(let response):
                if response.docs.isEmpty {
                    self.hasMoreData = false
                } else {
                    self.launches.append(contentsOf: response.docs)
                    self.currentPage += 1
                    self.onUpdate?()
                }
            case .failure(let error):
                self.onError?(error)
            }
        }
    }

    /// Loads the image for a given launch at the specified index path.
    ///
    /// - Parameter indexPath: The index path of the launch.
    func loadImage(for indexPath: IndexPath) {
        guard launches.indices.contains(indexPath.row) else { return }
        let launch = launches[indexPath.row]

        if let missionPatch = launch.links.patch?.small {
            ImageCacheManager.shared.loadImage(for: missionPatch) { [weak self] image, error in
                self?.onImageLoad?(indexPath, image)
            }
        }
    }

    /// Returns the number of launches.
    ///
    /// - Returns: The number of launches.
    func numberOfLaunches() -> Int {
        return launches.count
    }

    /// Returns the launch at the specified index.
    ///
    /// - Parameter index: The index of the launch.
    /// - Returns: The launch object, or nil if the index is out of bounds.
    func launch(at index: Int) -> Launch? {
        guard index >= 0 && index < launches.count else { return nil }
        return launches[index]
    }
}
