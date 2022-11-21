//
//  VCSignIn.swift
//  MoneyManager
//
//  Created by Roman on 21.11.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class VCSignIn: UIViewController {

  @IBOutlet var signInButton: UIButton!
  @IBOutlet var signUpButton: UIButton!

  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!

  @IBAction func signInButton(_ sender: Any) {
    Task {
      do {
        try await UserRepository.shared.signIn(email: emailTextField.text!, password: passwordTextField.text!)
        UserRepository.shared.listener = UserRepository.shared.auth.addStateDidChangeListener { [weak self] _, user in
          if let user = user {
            UserRepository.shared.user?.email = user.email!
            UserRepository.shared.userReference = Firestore.firestore().collection("users").document(user.email!)
            self!.performSegue(withIdentifier: "segueToVCMain", sender: nil)
          }
        }
      } catch {
        print("LogIn Error = \(error)")
      }
    }
  }

  @IBAction func logUpButton(_ sender: Any) {
    performSegue(withIdentifier: "segueToVCSignIn", sender: nil)
  }


  override func viewDidLoad() {
        super.viewDidLoad()

    }

}
