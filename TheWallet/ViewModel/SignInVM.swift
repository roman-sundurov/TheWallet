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
import AuthenticationServices

extension VCSignIn {

  func autoSignIn() {

    // Не используется, потому что Firebase сам управляет переподключением к аккаунту при перезагрузке приложения

    // let provider = UserDefaults.standard.object(forKey: "providerID") as? String
    // 
    // switch provider {
    // case "password":
    //   if let email = UserDefaults.standard.object(forKey: "email") as? String, let password = UserDefaults.standard.object(forKey: "password") as? String {
    //     guard !email.isEmpty || !password.isEmpty else {
    //       return
    //         // showLogInInformation()
    //     }
    //     print("email= \(email), password= \(password)")
    //     Task {
    //       do {
    //         try await UserRepository.shared.signIn(email: email, password: password)
    //       } catch {
    //         print("LogIn Error = \(error)")
    //         showMessagePrompt(error.localizedDescription)
    //           // showLogInInformation()
    //       }
    //     }
    // 
    //   } else {
    //     print("No login data")
    //       // showLogInInformation()
    //   }
    // case "google.com":
    //   GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
    //     if error != nil || user == nil {
    //         // Show the app's signed-out state.
    //     } else {
    //         // Show the app's signed-in state.
    //     }
    //   }
    // case "facebook.com":
    //   if let data = UserDefaults.standard.data(forKey: "facebookToken"),
    //      let accessToken = NSKeyedUnarchiver.unarchiveObject(with: data) as? AccessToken {
    //     let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
    //     Auth.auth().signIn(with: credential, completion: { (user, error) in
    //       if let error = error {
    //         print("Login error: \(error.localizedDescription)")
    //         self.showMessagePrompt(error.localizedDescription)
    //         return
    //       } else {
    //       }
    //     })
    //   }
    // 
    // // case "apple.com":
    // default:
    //   print("not autoSignIn")
    // }
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
    let credential = EmailAuthProvider.credential(withEmail: emailTextField.text!, password: passwordTextField.text!)
    // Auth.auth().currentUser!.link(with: credential) { authResult, error in
    //   print("email link(with: credential")
    // }

    Task {
      do {
        try await UserRepository.shared.signIn(email: emailTextField.text!, password: passwordTextField.text!)
        UserRepository.shared.listener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
          if let user = user {
            let defaults = UserDefaults.standard
            defaults.set(self?.emailTextField.text!, forKey: "email")
            defaults.set(self?.passwordTextField.text!, forKey: "password")

            // UserRepository.shared.user?.email = user.email!
            UserRepository.shared.userReference = Firestore.firestore().collection("users").document(user.email!)
            self!.emailSignInButton.configuration?.showsActivityIndicator = false
            self!.performSegue(withIdentifier: "segueToVCMain", sender: nil)
          }
        }
      } catch {
        print("LogIn Error = \(error)")
        emailSignInButton.configuration?.showsActivityIndicator = false
        showMessagePrompt(error.localizedDescription)
      }
    }
  }


  func googleSignIn() {
    guard let clientID = FirebaseApp.app()?.options.clientID else { return }
    GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
      guard error == nil else {
        self.showMessagePrompt(error!.localizedDescription)
        return
      }
      guard let signInResult = signInResult else { return }

      signInResult.user.refreshTokensIfNeeded { user, error in
        guard
          let accessToken = user?.accessToken,
          let idToken = user?.idToken
        else {
          return
        }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
        // Auth.auth().currentUser!.link(with: credential) { authResult, error in
        //   print("Google link(with: credential")
        // }

        Auth.auth().signIn(with: credential) { authResult, error in
          if let error = error {
            print("Login error: \(error.localizedDescription)")
            self.showMessagePrompt(error.localizedDescription)
            return
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
        self.showMessagePrompt(error.localizedDescription)
        return
      }

      guard let accessToken = AccessToken.current else {
        print("Failed to get access token")
        self.showMessagePrompt("Failed to get access token")
        return
      }
      let data = NSKeyedArchiver.archivedData(withRootObject: accessToken)
      UserDefaults.standard.set(data, forKey: "facebookToken")

      let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
      // Auth.auth().currentUser!.link(with: credential) { authResult, error in
      //   print("Facebook link(with: credential")
      // }

      // Perform login by calling Firebase APIs
      Auth.auth().signIn(with: credential, completion: { (user, error) in
        if let error = error {
          print("Login error: \(error.localizedDescription)")
          self.showMessagePrompt(error.localizedDescription)
          return
        } else {
        }
      })
    }

  }

}
