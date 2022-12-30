//
//  VCSignIn.swift
//  MoneyManager
//
//  Created by Roman on 21.11.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

import FacebookCore
import FacebookLogin
import FacebookShare

class VCSignIn: UIViewController {

  @IBOutlet var logInGroup: UIView!
  @IBOutlet var topConstraint: NSLayoutConstraint!

  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!

  @IBOutlet var emailSignInButton: UIButton!
  @IBOutlet var emailSignUpButton: UIButton!

  @IBOutlet var testButton: UIView!
  @IBOutlet var googleSignInView: GIDSignInButton!

  @IBAction func signInButton(_ sender: Any) {
    emailSignIn()
  }

  @IBAction func logUpButton(_ sender: Any) {
    performSegue(withIdentifier: "segueToVCSignIn", sender: nil)
  }

  @IBAction func googleSignInViewButton(_ sender: Any) {
    googleSignIn()
    print("googleSignInViewButton")
  }

  @IBAction func fbaction(_ sender: Any) {

    let loginManager = LoginManager()
    loginManager.logIn(permissions: ["public_profile", "email"], from: self) { (result, error) in
      if let error = error {
        print("Failed to login: \(error.localizedDescription)")
        return
      }

      guard let accessToken = AccessToken.current else {
        print("Failed to get access token")
        return
      }

      let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)

        // Perform login by calling Firebase APIs
      Auth.auth().signIn(with: credential, completion: { (user, error) in
        if let error = error {
          print("Login error: \(error.localizedDescription)")
          let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
          let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
          alertController.addAction(okayAction)
          self.present(alertController, animated: true, completion: nil)
          return
        }else {
          // self.currentUserName()
        }

      })

    }

  }

  func showLogInInformation() {
    UIView.animate(withDuration: 2, delay: 0) {
      self.topConstraint.constant = 100
      self.logInGroup.isHidden = false
    }
  }

  // MARK: viewWillDisapear
  func viewWillDisapear() {
    Auth.auth().removeStateDidChangeListener(UserRepository.shared.listener!)
  }

  // MARK: viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()

    let loginButton = FBLoginButton()
    loginButton.center = view.center
    testButton.addSubview(loginButton)

    if let token = AccessToken.current,
       !token.isExpired {
        // User is logged in, do work such as go to next view controller.
    }

    // let loginButton = FBLoginButton()
    // loginButton.center = facebookSignInView.center
    // loginButton.permissions = ["public_profile", "email"]
    // loginButton.addTarget(self, action: #selector(loginButton), for: .touchUpInside)
    // facebookSignInView.addSubview(loginButton)

    UserRepository.shared.listener = Auth.auth().addStateDidChangeListener() { (auth, user) in
      if let user = user {
        // MeasurementHelper.sendLoginEvent()
        UserRepository.shared.user?.email = user.email!
        UserRepository.shared.userReference = Firestore.firestore().collection("users").document(user.email!)
        self.performSegue(withIdentifier: "segueToVCMain", sender: nil)
      }
    }

    autoSignInEmail()

  }

  func showMessagePrompt(_ message: String) {
      let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alert.addAction(okAction)
      present(alert, animated: false, completion: nil)
    }

  func showTextInputPrompt(withMessage message: String,
                           completionBlock: @escaping ((Bool, String?) -> Void)) {
    let prompt = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
      completionBlock(false, nil)
    }
    weak var weakPrompt = prompt
    let okAction = UIAlertAction(title: "OK", style: .default) { _ in
      guard let text = weakPrompt?.textFields?.first?.text else { return }
      completionBlock(true, text)
    }
    prompt.addTextField(configurationHandler: nil)
    prompt.addAction(cancelAction)
    prompt.addAction(okAction)
    present(prompt, animated: true, completion: nil)
  }


}
