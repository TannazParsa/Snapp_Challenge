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

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
      window = UIWindow(frame: UIScreen.main.bounds)
      let launchListViewController = LaunchListViewController()
      let navigationController = UINavigationController(rootViewController: launchListViewController)
      window?.rootViewController = navigationController
      window?.makeKeyAndVisible()
      return true
  }
}

