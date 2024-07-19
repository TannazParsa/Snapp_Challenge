//
//  LaunchTablViewCell.swift
//  SnappChallenge
//
//  Created by tanaz on 29/04/1403 AP.
//

import Foundation
import UIKit

/// `LaunchTableViewCell` is a custom table view cell used to display details about a SpaceX launch.
class LaunchTableViewCell: UITableViewCell {

    // MARK: - UI Components

    private let missionImageView = UIImageView()
    private let missionNameLabel = UILabel()
    private let flightNumberLabel = UILabel()
    private let successLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()

    private var viewModel: LaunchListViewModel?
    private var indexPath: IndexPath?

    // MARK: - Initializers

    /// Initializes the cell with the given style and reuse identifier.
    ///
    /// - Parameters:
    ///   - style: The cell style.
    ///   - reuseIdentifier: The reuse identifier.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    /// Required initializer with a coder, which is not implemented.
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods

    /// Prepares the cell for reuse by resetting the mission image to a placeholder.
    override func prepareForReuse() {
        super.prepareForReuse()
        missionImageView.image = UIImage(named: "rocket-placeholder")
    }

    // MARK: - Setup Methods

    /// Sets up the user interface components and layout constraints.
    private func setupUI() {
        // Add subviews
        contentView.addSubview(missionImageView)
        contentView.addSubview(missionNameLabel)
        contentView.addSubview(flightNumberLabel)
        contentView.addSubview(successLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(dateLabel)

        // Configure subviews
        missionImageView.contentMode = .scaleAspectFill
        missionImageView.layer.cornerRadius = 8
        missionImageView.clipsToBounds = true

        missionNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        flightNumberLabel.font = UIFont.systemFont(ofSize: 14)
        successLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.numberOfLines = 0
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .gray

        // Disable autoresizing masks
        missionImageView.translatesAutoresizingMaskIntoConstraints = false
        missionNameLabel.translatesAutoresizingMaskIntoConstraints = false
        flightNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        successLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        // Setup constraints
        NSLayoutConstraint.activate([
            missionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            missionImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            missionImageView.widthAnchor.constraint(equalToConstant: 60),
            missionImageView.heightAnchor.constraint(equalToConstant: 60),

            missionNameLabel.leadingAnchor.constraint(equalTo: missionImageView.trailingAnchor, constant: 16),
            missionNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            missionNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),

            flightNumberLabel.leadingAnchor.constraint(equalTo: missionNameLabel.leadingAnchor),
            flightNumberLabel.topAnchor.constraint(equalTo: missionNameLabel.bottomAnchor, constant: 8),

            successLabel.leadingAnchor.constraint(equalTo: flightNumberLabel.trailingAnchor, constant: 16),
            successLabel.topAnchor.constraint(equalTo: missionNameLabel.bottomAnchor, constant: 8),

            descriptionLabel.leadingAnchor.constraint(equalTo: missionNameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: flightNumberLabel.bottomAnchor, constant: 8),

            dateLabel.leadingAnchor.constraint(equalTo: missionNameLabel.leadingAnchor),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Configuration Method

    /// Configures the cell with the given launch data, view model, and index path.
    ///
    /// - Parameters:
    ///   - launch: The launch data to display.
    ///   - viewModel: The view model responsible for managing the data.
    ///   - indexPath: The index path of the cell.
    func configure(with launch: Launch, viewModel: LaunchListViewModel, indexPath: IndexPath) {
        self.viewModel = viewModel
        self.indexPath = indexPath

        missionNameLabel.text = launch.name
        flightNumberLabel.text = "Flight \(launch.flightNumber)"
        successLabel.text = launch.success == true ? "Success" : "Failure"
        descriptionLabel.text = launch.details
        dateLabel.text = launch.localDateString

        // Request the image from the view model
        viewModel.loadImage(for: indexPath)
    }

    // MARK: - Update Image Method

    /// Updates the mission image view with the given image.
    ///
    /// - Parameter image: The image to display.
    func updateImage(_ image: UIImage?) {
        DispatchQueue.main.async {
            self.missionImageView.image = image
        }
    }
}
