//
//  SignInVM.swift
//  TheWallet
//
//  Created by Roman on 25.12.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import FacebookLogin

extension VCSignIn {

  func autoSignInEmail() {
    if let email = UserDefaults.standard.object(forKey: "email") as? String, let password = UserDefaults.standard.object(forKey: "password") as? String {
      guard !email.isEmpty || !password.isEmpty else {
        return
        // showLogInInformation()
      }
      print("email= \(email), password= \(password)")
      Task {
        do {
          try await UserRepository.shared.signIn(email: email, password: password)
        } catch {
          print("LogIn Error = \(error)")
          // showLogInInformation()
        }
      }

    } else {
      print("No login data")
      // showLogInInformation()
    }
  }

  func emailSignIn() {
    emailSignInButton.configuration?.showsActivityIndicator = true
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
        UserRepository.shared.listener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
          if let user = user {
            let defaults = UserDefaults.standard
            defaults.set(self?.emailTextField.text!, forKey: "email")
            defaults.set(self?.passwordTextField.text!, forKey: "password")

            UserRepository.shared.user?.email = user.email!
            UserRepository.shared.userReference = Firestore.firestore().collection("users").document(user.email!)
            self!.emailSignInButton.configuration?.showsActivityIndicator = false
            self!.performSegue(withIdentifier: "segueToVCMain", sender: nil)
          }
        }
      } catch {
        print("LogIn Error = \(error)")
        emailSignInButton.configuration?.showsActivityIndicator = false
      }
    }
  }


  func googleSignIn() {
    guard let clientID = FirebaseApp.app()?.options.clientID else { return }
    GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
      guard error == nil else { return }
      guard let signInResult = signInResult else { return }

      signInResult.user.refreshTokensIfNeeded { user, error in
        guard
          let accessToken = user?.accessToken,
          let idToken = user?.idToken
        else {
          return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)

        Auth.auth().signIn(with: credential) { authResult, error in
          if let error = error {
            print("Login error: \(error.localizedDescription)")
            let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
            let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okayAction)
            self.present(alertController, animated: true, completion: nil)
            return
              // User is signed in
              // ...
          }
        }

      }
    }
    
  }

  func facebookSignIn() {
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


}
