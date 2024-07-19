//
//  LaunchListViewController.swift
//  SnappChallenge
//
//  Created by tanaz on 29/04/1403 AP.
//


import UIKit

class LaunchListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let tableView = UITableView()
    private let viewModel = LaunchListViewModel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let footerActivityIndicator = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupActivityIndicator()
        setupViewModel()
        viewModel.fetchLaunches()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LaunchTableViewCell.self, forCellReuseIdentifier: "LaunchCell")
        view.addSubview(tableView)

        // Setup constraints or layout for tableView
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

    private func setupActivityIndicator() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

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

        viewModel.onError = { error in
            // Handle error
            print("Error: \(error)")
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfLaunches()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LaunchCell", for: indexPath) as! LaunchTableViewCell
        if let launch = viewModel.launch(at: indexPath.row) {
            cell.configure(with: launch, viewModel: viewModel, indexPath: indexPath)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.numberOfLaunches() - 1 { // If it's the last cell
            viewModel.fetchLaunches(isPagination: true)
        }
    }
}
