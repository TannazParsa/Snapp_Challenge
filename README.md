# SnappChallenge

## Overview

**SnappChallenge** is an iOS application that displays a list of SpaceX launches using a `UITableView`. The app features pagination, launch details, bookmarking functionality, and integration with Wikipedia links. It follows the MVVM (Model-View-ViewModel) design pattern.

## Features

- **Launch List:** Displays a paginated list of SpaceX launches.
- **Launch Details:** View detailed information about a selected launch, including an image, mission name, flight number, description, and launch date.
- **Bookmarking:** Allows users to bookmark or unbookmark launches.
- **Wikipedia Integration:** Opens the Wikipedia page related to the launch if available.
- **Image Caching:** Efficiently loads and caches mission images for performance.

### Requirements

- iOS 13.0 or later
- Xcode 11.0 or later

**Architecture:**
##MVVM Design Pattern##
- **Model:** Represents the data layer (e.g., Launch, LaunchResponse, NetworkService).
- **View:** UI components that display data (e.g., LaunchListViewController, LaunchDetailViewController, LaunchTableViewCell).
- **ViewModel:** Manages the data for views and handles business logic (e.g., LaunchListViewModel, LaunchDetailViewModel).
 **Network Requests**
- **NetworkService:** Handles API requests to fetch launch data and manage network operations.
- **ImageCacheManager:** Manages image caching and loading to enhance performance and reduce network usage.


**Usage:**
**Launch List Screen**
- **View Launches:** Browse through a list of SpaceX launches with pagination.
- **Select Launch:** Tap on a launch to view detailed information.



**Launch Detail Screen**
- **Mission Image:** Displays an image related to the launch.
- **Mission Name & Flight Number:** Shows the mission's name and flight number.
- **Description:** Provides a description of the launch.
- **Date:** Displays the date of the launch.
- **Bookmark Launch:** Tap the "Bookmark" button to save or remove the launch from bookmarks.
- **Open Wikipedia:** Tap the "Open Wikipedia" button to view the mission’s Wikipedia page if available.
