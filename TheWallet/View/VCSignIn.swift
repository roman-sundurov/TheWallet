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

class VCSignIn: UIViewController {

  @IBOutlet var logInGroup: UIView!
  @IBOutlet var topConstraint: NSLayoutConstraint!

  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!

  @IBOutlet var emailSignInButton: UIButton!
  @IBOutlet var emailSignUpButton: UIButton!

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

    GIDSignIn.sharedInstance.restorePreviousSignIn()
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
