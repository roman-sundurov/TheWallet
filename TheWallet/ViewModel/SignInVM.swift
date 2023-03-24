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
import AuthenticationServices

extension VCSignIn {

    func emailSignIn() throws {
        emailSignInButton.configuration?.showsActivityIndicator = true

        // let credential = EmailAuthProvider.credential(withEmail: emailTextField.text!, password: passwordTextField.text!)

        if let emailText = emailTextField.text,
           let passwordText = passwordTextField.text,
           emailText != "",
           passwordText != "" {

            Task {
                do {
                    try await UserRepository.shared.signIn(email: emailText, password: passwordText)
                    UserRepository.shared.listener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
                        if let user = user,
                           let userEmail = user.email {
                            let defaults = UserDefaults.standard
                            defaults.set(emailText, forKey: "email")
                            defaults.set(passwordText, forKey: "password")

                            // UserRepository.shared.user?.email = user.email!
                            UserRepository.shared.userReference = Firestore.firestore().collection("users").document(userEmail)
                            self!.emailSignInButton.configuration?.showsActivityIndicator = false
                            self!.performSegue(withIdentifier: PerformSegueIdentifiers.segueToVCMain.rawValue, sender: nil)
                        }
                    }
                } catch {
                    print("LogIn Error = \(error)")
                    emailSignInButton.configuration?.showsActivityIndicator = false
                    showMessagePrompt(error.localizedDescription)
                }
            }
        } else {
            throw ThrowError.emptyInputFields
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

}
