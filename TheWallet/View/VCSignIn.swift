//
//  VCSignIn.swift
//  MoneyManager
//
//  Created by Roman on 21.11.2022.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import FirebaseFirestore
import FirebaseFirestoreSwift

class VCSignIn: UIViewController {

  @IBOutlet var logInGroup: UIView!
  @IBOutlet var topConstraint: NSLayoutConstraint!

  @IBOutlet var signInButton: UIButton!
  @IBOutlet var signUpButton: UIButton!

  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!

  @IBAction func googleignInViewButton(_ sender: Any) {
    googleSignIn()
    print("googleignInViewButton")
  }

  @IBAction func signInButton(_ sender: Any) {
    // if !emailTextField.text!.isEmpty && passwordTextField.text!.isEmpty {
    //   let actionCodeSettings = ActionCodeSettings()
    //   actionCodeSettings.url = URL(string: "https://www.example.com")
    //   // The sign-in operation has to always be completed in the app.
    //   actionCodeSettings.handleCodeInApp = true
    //   actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
    //   actionCodeSettings.setAndroidPackageName("com.example.android", installIfNotAvailable: false, minimumVersion: "12")
    //
    //   Auth.auth().sendSignInLink(toEmail: emailTextField.text!, actionCodeSettings: actionCodeSettings) { error in
    //     // ...
    //       if let error = error {
    //         // self.showMessagePrompt(error.localizedDescription)
    //         print("showMessagePrompt= \(error.localizedDescription)")
    //         return
    //       }
    //       // The link was successfully sent. Inform the user.
    //       // Save the email locally so you don't need to ask the user for it again
    //       // if they open the link on the same device.
    //     UserDefaults.standard.set(self.emailTextField.text!, forKey: "Email")
    //     print("Check your email for link")
    //       // self.showMessagePrompt("Check your email for link")
    //       // ...
    //   }
    //
    //
    // } else {
      Task {
        do {
          try await UserRepository.shared.signIn(email: emailTextField.text!, password: passwordTextField.text!)
          UserRepository.shared.listener = UserRepository.shared.auth.addStateDidChangeListener { [weak self] _, user in
            if let user = user {
              let defaults = UserDefaults.standard
              defaults.set(self?.emailTextField.text!, forKey: "email")
              defaults.set(self?.passwordTextField.text!, forKey: "password")

              UserRepository.shared.user?.email = user.email!
              UserRepository.shared.userReference = Firestore.firestore().collection("users").document(user.email!)
              self!.performSegue(withIdentifier: "segueToVCMain", sender: nil)
            }
          }
        } catch {
          print("LogIn Error = \(error)")
        }
      }
    // }
  }

  @IBAction func logUpButton(_ sender: Any) {
    performSegue(withIdentifier: "segueToVCSignIn", sender: nil)
  }

  func showLogInInformation() {
    UIView.animate(withDuration: 2, delay: 0) {
      self.topConstraint.constant = 100
      self.logInGroup.isHidden = false
    }
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


    // let defaults = UserDefaults.standard
    // // var email = defaults.object(forKey: "email") as? String
    // // let password = defaults.object(forKey: "password") as? String

    if let email = UserDefaults.standard.object(forKey: "email") as? String, let password = UserDefaults.standard.object(forKey: "password") as? String {
      guard !email.isEmpty || !password.isEmpty else {
        return
        showLogInInformation()
      }
      print("email= \(email), password= \(password)")
      Task {
        do {
          try await UserRepository.shared.signIn(email: email, password: password)
          UserRepository.shared.listener = UserRepository.shared.auth.addStateDidChangeListener { [weak self] _, user in
            if let user = user {
              let defaults = UserDefaults.standard
              defaults.set(self?.emailTextField.text!, forKey: "email")
              defaults.set(self?.passwordTextField.text!, forKey: "password")

              UserRepository.shared.user?.email = user.email!
              UserRepository.shared.userReference = Firestore.firestore().collection("users").document(user.email!)
              self!.performSegue(withIdentifier: "segueToVCMain", sender: nil)
            }
          }
        } catch {
          print("LogIn Error = \(error)")
          showLogInInformation()
        }
      }

    } else {
      print("No login data")
      showLogInInformation()
    }

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


  func googleSignIn() {
    guard let clientID = FirebaseApp.app()?.options.clientID else { return }

      // Create Google Sign In configuration object.
    let config = GIDConfiguration(clientID: clientID)
      // Start the sign in flow!
    GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
      if let error = error {
          // ...
        return
      }
      guard
        let authentication = user?.authentication,
        let idToken = authentication.idToken
      else {
        return
      }
      let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

      Auth.auth().signIn(with: credential) { authResult, error in
        if let error = error {
          print("Error GoogleSignIn= \(error.localizedDescription)")

          let authError = error as NSError
          let isMFAEnabled = false

          // Code for multi-factor authentication
          //
          // if isMFAEnabled, authError.code == AuthErrorCode.secondFactorRequired.rawValue {
          //   // The user is a multi-factor user. Second factor challenge is required.
          //   let resolver = authError
          //     .userInfo[AuthErrorUserInfoMultiFactorResolverKey] as? MultiFactorResolver
          //   var displayNameString = ""
          //   for tmpFactorInfo in resolver!.hints {
          //     displayNameString += tmpFactorInfo.displayName ?? ""
          //     displayNameString += " "
          //   }
          //   self.showTextInputPrompt(
          //     withMessage: "Select factor to sign in\n\(displayNameString)",
          //     completionBlock: { userPressedOK, displayName in
          //       var selectedHint: PhoneMultiFactorInfo?
          //       for tmpFactorInfo in resolver!.hints {
          //         if displayName == tmpFactorInfo.displayName {
          //           selectedHint = tmpFactorInfo as? PhoneMultiFactorInfo
          //         }
          //       }
          //       PhoneAuthProvider.provider()
          //         .verifyPhoneNumber(with: selectedHint!, uiDelegate: nil,
          //                            multiFactorSession: resolver?
          //                              .session) { verificationID, error in
          //           if error != nil {
          //             print(
          //               "Multi factor start sign in failed. Error: \(error.debugDescription)"
          //             )
          //           } else {
          //             self.showTextInputPrompt(
          //               withMessage: "Verification code for \(selectedHint?.displayName ?? "")",
          //               completionBlock: { userPressedOK, verificationCode in
          //                 let credential: PhoneAuthCredential? = PhoneAuthProvider.provider()
          //                   .credential(withVerificationID: verificationID!,
          //                               verificationCode: verificationCode!)
          //                 let assertion: MultiFactorAssertion? = PhoneMultiFactorGenerator
          //                   .assertion(with: credential!)
          //                 resolver!.resolveSignIn(with: assertion!) { authResult, error in
          //                   if error != nil {
          //                     print(
          //                       "Multi factor finanlize sign in failed. Error: \(error.debugDescription)"
          //                     )
          //                   } else {
          //                     self.navigationController?.popViewController(animated: true)
          //                   }
          //                 }
          //               }
          //             )
          //           }
          //         }
          //     }
          //   )
          // } else {
            self.showMessagePrompt(error.localizedDescription)
            return
          // }
          // return
        }

        UserRepository.shared.listener = UserRepository.shared.auth.addStateDidChangeListener { [weak self] _, user in
          if let user = user {
            let defaults = UserDefaults.standard
            defaults.set(user.email, forKey: "email")
            defaults.set("", forKey: "password")

            UserRepository.shared.user?.email = user.email!
            UserRepository.shared.userReference = Firestore.firestore().collection("users").document(user.email!)
            self!.performSegue(withIdentifier: "segueToVCMain", sender: nil)
          }
        }

      }
    }
  }

}
