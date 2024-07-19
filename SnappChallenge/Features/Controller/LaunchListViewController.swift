//
//  LaunchListViewController.swift
//  SnappChallenge
//
//  Created by tanaz on 29/04/1403 AP.
//

import UIKit

/// `LaunchListViewController` is responsible for displaying a list of SpaceX launches.
/// It uses a `UITableView` to show the launches and provides pagination and loading indicators.
class LaunchListViewController: UIViewController {

    // MARK: - Properties

    private let tableView = UITableView()
    private let viewModel = LaunchListViewModel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let footerActivityIndicator = UIActivityIndicatorView(style: .medium)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SpaceX"
        setupTableView()
        setupActivityIndicator()
        setupViewModel()
        viewModel.fetchLaunches()
    }

    // MARK: - Setup Methods

    /// Sets up the `UITableView` with data source, delegate, and layout constraints.
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LaunchTableViewCell.self, forCellReuseIdentifier: "LaunchCell")
        view.addSubview(tableView)

        // Setup constraints for tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Setup footer view for pagination loading indicator
        footerActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
        footerView.addSubview(footerActivityIndicator)
        NSLayoutConstraint.activate([
            footerActivityIndicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            footerActivityIndicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
        tableView.tableFooterView = footerView
    }

    /// Sets up the main activity indicator in the center of the view.
    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    /// Sets up the bindings to the `LaunchListViewModel`.
    private func setupViewModel() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        viewModel.onImageLoad = { [weak self] indexPath, image in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if let cell = self.tableView.cellForRow(at: indexPath) as? LaunchTableViewCell {
                    cell.updateImage(image)
                }
            }
        }

        viewModel.onError = { [weak self] error in
            DispatchQueue.main.async {
                self?.showErrorAlert(message: error.localizedDescription)
            }
        }

        viewModel.onLoadingStateChange = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }

        viewModel.onPaginationLoadingStateChange = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.footerActivityIndicator.startAnimating()
                } else {
                    self?.footerActivityIndicator.stopAnimating()
                }
            }
        }
    }

    /// Shows an error alert with the provided message.
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
extension LaunchListViewController: UITableViewDelegate, UITableViewDataSource {
  // MARK: - UITableViewDelegate

  /// Triggers fetching more launches when the last cell is displayed (for pagination).
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
      if indexPath.row == viewModel.numberOfLaunches() - 1 { // If it's the last cell
          viewModel.fetchLaunches(isPagination: true)
      }
  }

  /// Navigates to the `LaunchDetailViewController` when a cell is selected.
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if let launch = viewModel.launch(at: indexPath.row) {
          tableView.deselectRow(at: indexPath, animated: true)
          let detailViewModel = LaunchDetailViewModel(launch: launch)
          let detailViewController = LaunchDetailViewController(viewModel: detailViewModel)
          navigationController?.pushViewController(detailViewController, animated: true)
      }
  }

  // MARK: - UITableViewDataSource

  /// Returns the number of rows in the section, which is the number of launches.
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return viewModel.numberOfLaunches()
  }

  /// Configures and returns the cell for the given index path.
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "LaunchCell", for: indexPath) as! LaunchTableViewCell
      if let launch = viewModel.launch(at: indexPath.row) {
          cell.configure(with: launch, viewModel: viewModel, indexPath: indexPath)
      }
      return cell
  }
}
