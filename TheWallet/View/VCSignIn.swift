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

    @IBOutlet var emailTextView: RoundedView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextView: RoundedView!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var emailSignInButton: UIButton!
    @IBOutlet var emailSignUpButton: UIButton!
    @IBOutlet var appleSignInButton: AppleSignInShadowButton!

    @IBOutlet var scrollViewBottomConstraint: NSLayoutConstraint!
    var keyboardHeight: CGFloat = 0 // хранит высоту клавиатуры
    var tapOutsideTextViews: UITapGestureRecognizer?

    @IBAction func signInButton(_ sender: Any) {
        do {
             try emailSignIn()
        } catch {
            showMessagePrompt("Fill in the email and password fields")
        }
    }

    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: SegueIdentifiers.segueToVCSignIn.rawValue, sender: nil)
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
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appleIDStateDidRevoked(_:)),
            name: ASAuthorizationAppleIDProvider.credentialRevokedNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDisappear),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillAppear),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tapOutsideTextViews = UITapGestureRecognizer(
            target: self,
            action: #selector(self.tapHandler(tap:))
        )
        if let tapOutsideTextViews = tapOutsideTextViews {
            self.view.addGestureRecognizer(tapOutsideTextViews)
        } else {
            print("Error: VCSignIn addGestureRecognizer")
        }

        emailTextField.delegate = self
        emailTextField.inputAccessoryView = createDoneButton()
        passwordTextField.delegate = self
        passwordTextField.inputAccessoryView = createDoneButton()

        UserRepository.shared.listener = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user,
               let email = user.email {
                UserRepository.shared.userReference = Firestore.firestore().collection("users").document(email)

                print("signInMethod= \(user.providerID)")
                self.performSegue(withIdentifier: SegueIdentifiers.segueToVCRootController.rawValue, sender: nil)
            }
        }
    }

}
