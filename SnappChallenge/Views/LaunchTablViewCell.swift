//
//  LaunchTablViewCell.swift
//  SnappChallenge
//
//  Created by tanaz on 29/04/1403 AP.
//

import Foundation
import UIKit

class LaunchTableViewCell: UITableViewCell {
    private let missionImageView = UIImageView()
    private let missionNameLabel = UILabel()
    private let flightNumberLabel = UILabel()
    private let successLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()

    private var viewModel: LaunchListViewModel?
    private var indexPath: IndexPath?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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

    func updateImage(_ image: UIImage?) {
      DispatchQueue.main.async {
        
        self.missionImageView.image = image
      }
    }
}

