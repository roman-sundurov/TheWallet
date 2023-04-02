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

    // MARK: - signIn functions
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
            emailSignInButton.configuration?.showsActivityIndicator = false
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

    @objc func appleIDStateDidRevoked(_ notification: Notification) {
            // Make sure user signed in with Apple
        if let providerId =  Auth.auth().currentUser?.providerData.first?.providerID,
           providerId == "apple.com" {
            UserRepository.shared.logOut()
        }
    }

    func showMessagePrompt(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: false, completion: nil)
    }

    private func showTextInputPrompt(
        withMessage message: String,
        completionBlock: @escaping ((Bool, String?) -> Void)
    ) {
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

    // MARK: - keyboard avioding
    @objc func tapHandler(tap: UITapGestureRecognizer) {
        if tap.state == UIGestureRecognizer.State.ended {
            print("Tap TextView ended")
            let pointOfTap = tap.location(in: self.view)
            if !emailTextView.frame.contains(pointOfTap) &&
                !passwordTextView.frame.contains(pointOfTap) {
                emailTextView.endEditing(true)
                passwordTextView.endEditing(true)
                print("Tap inside TextViews")
            }
        }
    }

    func tapOutsideTextViewEditToHide() {
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        print("textViewDeselect")
    }

    @objc func keyboardWillAppear(_ notification: Notification) {
        print("keyboardWillAppear")
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: UIView.AnimationOptions(),
            animations: {
                if self.scrollViewBottomConstraint.constant == 0 {
                    self.scrollViewBottomConstraint.constant = self.keyboardHeight + CGFloat.init(0)
                }
                self.view.layoutIfNeeded()
            },
            completion: { _ in }
        )
    }

    @objc func keyboardWillDisappear(_ notification: Notification) {
        if keyboardHeight != 0 {
            print("keyboardWillDisappear")
            keyboardHeight = 0
            UIView.animate(
                withDuration: 0.5,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: UIView.AnimationOptions(),
                animations: {
                    if self.scrollViewBottomConstraint.constant > 0 {
                        self.scrollViewBottomConstraint.constant = CGFloat.init(0)
                    }
                    self.view.layoutIfNeeded()
                },
                completion: { _ in }
            )
        }
    }

}

extension VCSignIn: UITextFieldDelegate {
    func createDoneButton() -> UIView {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        return doneToolbar
    }

    @objc func doneButtonAction() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

}
