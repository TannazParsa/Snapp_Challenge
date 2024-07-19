//
//  LaunchListViewModel.swift
//  SnappChallenge
//
//  Created by tanaz on 29/04/1403 AP.
//

import Foundation
import UIKit

class LaunchListViewModel {
    private var launches: [Launch] = []
    private var currentPage: Int = 1
    private var isFetching: Bool = false
    private var hasMoreData: Bool = true
    var onUpdate: (() -> Void)?
    var onError: ((NetworkError) -> Void)?
    var onImageLoad: ((IndexPath, UIImage?) -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?
    var onPaginationLoadingStateChange: ((Bool) -> Void)?

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

    func loadImage(for indexPath: IndexPath) {
        guard launches.indices.contains(indexPath.row) else { return }
        let launch = launches[indexPath.row]

        if let missionPatch = launch.links.patch?.small, let url = URL(string: missionPatch) {
            NetworkService.shared.loadImage(from: url) { [weak self] result in
                switch result {
                case .success(let image):
                    self?.onImageLoad?(indexPath, image)
                case .failure(let error):
                    print("Failed to load image: \(error)")
                    self?.onImageLoad?(indexPath, nil)
                }
            }
        }
    }

    func numberOfLaunches() -> Int {
        return launches.count
    }

    func launch(at index: Int) -> Launch? {
        guard index >= 0 && index < launches.count else { return nil }
        return launches[index]
    }
}
