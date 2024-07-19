//
//  LaunchDetailViewController.swift
//  SnappChallenge
//
//  Created by tanaz on 30/04/1403 AP.
//

import Foundation
import UIKit

/// `LaunchDetailViewController` is responsible for displaying detailed information about a specific SpaceX launch.
/// It uses a `LaunchDetailViewModel` to manage the data and provides options to bookmark the launch and open its Wikipedia page.
class LaunchDetailViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: LaunchDetailViewModel

    private let missionImageView = UIImageView()
    private let missionNameLabel = UILabel()
    private let flightNumberLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let bookmarkButton = UIButton(type: .system)
    private let wikipediaButton = UIButton(type: .system)

    // MARK: - Initializers

    /// Initializes the view controller with a given view model.
    ///
    /// - Parameter viewModel: The view model that provides launch details.
    init(viewModel: LaunchDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    /// Required initializer with a coder, which is not implemented.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureUI()
        setupBindings()
    }

    // MARK: - Setup Methods

    /// Sets up the user interface components and layout.
    private func setupUI() {
        view.backgroundColor = .white

        missionImageView.contentMode = .scaleAspectFit
        missionNameLabel.font = .boldSystemFont(ofSize: 20)
        flightNumberLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        dateLabel.font = .italicSystemFont(ofSize: 14)
        bookmarkButton.setTitle("Bookmark", for: .normal)
        wikipediaButton.setTitle("Open Wikipedia", for: .normal)

        let stackView = UIStackView(arrangedSubviews: [missionImageView, missionNameLabel, flightNumberLabel, descriptionLabel, dateLabel, bookmarkButton, wikipediaButton])
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        missionImageView.image = UIImage(named: "rocket-placeholder")

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            missionImageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    /// Configures the UI elements with data from the view model.
    private func configureUI() {
        missionNameLabel.text = viewModel.missionName
        flightNumberLabel.text = viewModel.flightNumber
        descriptionLabel.text = viewModel.missionDetails
        dateLabel.text = viewModel.missionDate

        if let imageURL = viewModel.missionImageURL {
            // Load image using URLSession or any other method
            ImageCacheManager.shared.loadImage(for: imageURL) { [weak self] image, error in
                DispatchQueue.main.async {
                    self?.missionImageView.image = image
                }
            }
        }

        updateBookmarkButton()

        if viewModel.wikipediaURL != nil {
            wikipediaButton.addTarget(self, action: #selector(openWikipedia), for: .touchUpInside)
        } else {
            wikipediaButton.isHidden = true
        }

        bookmarkButton.addTarget(self, action: #selector(toggleBookmark), for: .touchUpInside)
    }

    /// Sets up bindings for the view model's properties and actions.
    private func setupBindings() {
        viewModel.onBookmarkStatusChange = { [weak self] in
            self?.updateBookmarkButton()
        }
    }

    /// Updates the bookmark button's title based on the bookmark status.
    private func updateBookmarkButton() {
        let title = viewModel.isBookmarked ? "Remove Bookmark" : "Add Bookmark"
        bookmarkButton.setTitle(title, for: .normal)
    }

    // MARK: - Actions

    /// Opens the launch's Wikipedia page in the default web browser.
    @objc private func openWikipedia() {
        if let url = viewModel.wikipediaURL {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    /// Toggles the bookmark status for the launch.
    @objc private func toggleBookmark() {
        viewModel.toggleBookmark()
    }
}
