//
//  ImageCacheManager.swift
//  SnappChallenge
//
//  Created by tanaz on 30/04/1403 AP.
//

import Foundation
import UIKit

/// A singleton manager for caching and loading images.
class ImageCacheManager {

    // MARK: - Properties

    /// The in-memory cache for storing image data.
    private var cache = NSCache<NSString, NSData>()

    /// The shared instance of `ImageCacheManager` for global access.
    static let shared = ImageCacheManager()

    // MARK: - Initialization

    /// Private initializer to ensure that `ImageCacheManager` is a singleton.
    private init() {}

    // MARK: - Public Methods

    /**
     Loads an image from the cache or downloads it if not available.

     - Parameter urlString: The URL of the image to load.
     - Parameter completion: A closure that gets called with the loaded image and URL string once the image is either cached or downloaded.

     This method first checks if the image data is available in the cache. If so, it creates a `UIImage` from the cached data and returns it. If the image is not cached, it initiates a network request to download the image. Once the image is downloaded, it caches the data for future use and returns the image.
     */
    func loadImage(for urlString: String, completion: @escaping (UIImage?, String) -> ()) {
        // Check the cache first
        if let cachedData = cache.object(forKey: urlString as NSString) {
            let image = UIImage(data: cachedData as Data)
            DispatchQueue.main.async {
                completion(image, urlString)
            }
            return
        }

        // If not cached, download the image
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(nil, urlString)
            }
            return
        }

        let downloadTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Error loading image: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(nil, urlString)
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, urlString)
                }
                return
            }

            // Cache the image data
            self?.cache.setObject(data as NSData, forKey: urlString as NSString)

            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image, urlString)
            }
        }
        downloadTask.resume()
    }
}
