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
        do {
             try emailSignIn()
        } catch {
            showMessagePrompt("Fill in the email and password fields")
        }
    }

    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: PerformSegueIdentifiers.segueToVCSignIn.rawValue, sender: nil)
    }

    @IBAction func googleSignInButton(_ sender: Any) {
        googleSignIn()
        print("googleSignInButton")
    }

    // MARK: - lifecycle
    func viewWillDisapear() {
        if let firebaseAuthListener = UserRepository.shared.listener {
            Auth.auth().removeStateDidChangeListener(firebaseAuthListener)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(
            self,
            name: ASAuthorizationAppleIDProvider.credentialRevokedNotification,
            object: nil
        )
    }

    override func viewWillAppear(_ animated: Bool) {
            // Register to Apple ID credential revoke notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appleIDStateDidRevoked(_:)),
            name: ASAuthorizationAppleIDProvider.credentialRevokedNotification,
            object: nil
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        UserRepository.shared.listener = Auth.auth().addStateDidChangeListener() { (auth, user) in
            if let user = user,
               let email = user.email {
                // MeasurementHelper.sendLoginEvent()
                // UserRepository.shared.user?.email = email
                UserRepository.shared.userReference = Firestore.firestore().collection("users").document(email)

                print("signInMethod= \(user.providerID)")
                self.performSegue(withIdentifier: PerformSegueIdentifiers.segueToVCMain.rawValue, sender: nil)
            }
        }
    }

    // MARK: - other functions
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

}
