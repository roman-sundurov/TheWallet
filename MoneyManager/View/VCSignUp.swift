//
//  VCSignIn.swift
//  MoneyManager
//
//  Created by Roman on 21.11.2022.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class VCSignUp: UIViewController {

  @IBOutlet var nameTextField: UITextField!
  @IBOutlet var surnameTextField: UITextField!
  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!

  @IBOutlet var signUpButton: UIButton!
  @IBOutlet var signInButton: UIButton!

  @IBAction func signUpButton(_ sender: Any) {
    Task {
      do {
        try await UserRepository.shared.createAccount(name: nameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!)
        UserRepository.shared.listener = UserRepository.shared.auth.addStateDidChangeListener { [weak self] _, user in
          if let user = user {
            UserRepository.shared.userReference = Firestore.firestore().collection("users").document(user.email!)
            UserRepository.shared.addNewUser(name: self!.nameTextField.text!, surname: self!.surnameTextField.text!, email: self!.emailTextField.text!)
            self!.performSegue(withIdentifier: "segueToVCMain", sender: nil)
          }
        }
      } catch {
        print("LogIn Error = \(error)")
      }
    }
  }

  @IBAction func signInButton(_ sender: Any) {
    performSegue(withIdentifier: "segueToVCSignIn", sender: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

}
