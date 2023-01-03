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

// Google SignIn
import GoogleSignIn

// Facebok SignIn
import FacebookCore
import FacebookLogin
import FacebookShare

// Apple SignIn
import AuthenticationServices


// @IBDesignable
class VCSignIn: UIViewController {
  @IBOutlet var logInGroup: UIView!
  // @IBOutlet var topConstraint: NSLayoutConstraint!

  @IBOutlet var emailTextView: RoundedView!
  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var passwordTextView: RoundedView!
  @IBOutlet var passwordTextField: UITextField!
  
  @IBOutlet var emailSignInButton: UIButton!
  @IBOutlet var emailSignUpButton: UIButton!

  @IBOutlet var appleSignInButton: AppleSignInShadowButton!

  @IBAction func signInButton(_ sender: Any) {
    emailSignIn()
  }

  @IBAction func signUpButton(_ sender: Any) {
    performSegue(withIdentifier: "segueToVCSignIn", sender: nil)
  }

  @IBAction func googleSignInButton(_ sender: Any) {
    googleSignIn()
    print("googleSignInButton")
  }

  @IBAction func facebookSignInButton(_ sender: Any) {
    facebookSignIn()
  }

  // func showLogInInformation() {
  //   UIView.animate(withDuration: 2, delay: 0) {
  //     // self.topConstraint.constant = 100
  //     self.logInGroup.isHidden = false
  //   }
  // }

  // MARK: viewWillDisapear
  func viewWillDisapear() {
    Auth.auth().removeStateDidChangeListener(UserRepository.shared.listener!)
  }

  @objc func appleIDStateRevoked() {
      // log out user, change UI etc
  }

  // MARK: viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()

    // if let userID = UserDefaults.standard.string(forKey: "userID") {
    //   ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID, completion: {
    //     credentialState, error in
    //
    //     switch(credentialState){
    //     case .authorized:
    //       print("user remain logged in, proceed to another view")
    //       self.performSegue(withIdentifier: "LoginToUserSegue", sender: nil)
    //     case .revoked:
    //       print("user logged in before but revoked")
    //     case .notFound:
    //       print("user haven't log in before")
    //     default:
    //       print("unknown state")
    //     }
    //   })
    // }

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(appleIDStateRevoked),
      name: ASAuthorizationAppleIDProvider.credentialRevokedNotification,
      object: nil
      )

    UserRepository.shared.listener = Auth.auth().addStateDidChangeListener() { (auth, user) in
      if let user = user {
        // MeasurementHelper.sendLoginEvent()
        UserRepository.shared.user?.email = user.email!
        UserRepository.shared.userReference = Firestore.firestore().collection("users").document(user.email!)
        UserRepository.shared.signInMethod = user.providerID
        UserDefaults.standard.set(user.providerID, forKey: "providerID")

        print("signInMethod= \(user.providerID)")
        self.performSegue(withIdentifier: "segueToVCMain", sender: nil)
      }
    }
    
    appleSignInButtonPreparation()
    autoSignIn()

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
