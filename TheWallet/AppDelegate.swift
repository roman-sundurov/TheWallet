//
//  AppDelegate.swift
//  MoneyManager
//
//  Created by Roman on 07.01.2021.
//

// import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import FacebookLogin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // Firebase setup
    FirebaseApp.configure()
    // Facebook sign in signIn setup
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

    // autoSignIn()
    return true
  }

  // MARK: UISceneSession Lifecycle
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  // func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
  // }

  func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    let handled = GIDSignIn.sharedInstance.handle(url)
    if handled {
      return true
    }

    ApplicationDelegate.shared.application(
      application,
      open: url,
      sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
      annotation: options[UIApplication.OpenURLOptionsKey.annotation]
    )
    return false
  }


}
