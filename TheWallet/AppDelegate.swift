//
//  AppDelegate.swift
//  MoneyManager
//
//  Created by Roman on 07.01.2021.
//

import UIKit
import FirebaseCore
import GoogleSignIn


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
  FirebaseApp.configure()

  GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
      if error != nil || user == nil {
        // Show the app's signed-out state.
      } else {
        // Show the app's signed-in state.
      }
    }
  
  return true
}

  // MARK: UISceneSession Lifecycle
func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
  return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
  }

  @available(iOS 9.0, *)
  func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
    let handled = GIDSignIn.sharedInstance.handle(url)
      if handled {
        return true
      }

      // Handle other custom URL types.

      // If not handled by this app, return false.
      return false
  }

}
