//
//  AppDelegate.swift
//  SnappChallenge
//
//  Created by tanaz on 29/04/1403 AP.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  // This method is called when the app has finished launching
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

    // Create a new UIWindow instance with the size of the screen's bounds
    window = UIWindow(frame: UIScreen.main.bounds)

    // Initialize the LaunchListViewController as the root view controller
    let launchListViewController = LaunchListViewController()

    // Embed LaunchListViewController inside a UINavigationController for navigation capabilities
    let navigationController = UINavigationController(rootViewController: launchListViewController)

    // Set the root view controller of the window to the navigation controller
    window?.rootViewController = navigationController

    // Make the window key and visible to display it on the screen
    window?.makeKeyAndVisible()

    // Return true to indicate that the app has successfully launched
    return true
  }
}

