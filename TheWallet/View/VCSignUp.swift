//
//  VCSignIn.swift
//  MoneyManager
//
//  Created by Roman on 21.11.2022.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class VCSignUp: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var surnameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var signInButton: UIButton!

    @IBAction func signUpButton(_ sender: Any) {
        if let nameTextField = nameTextField.text,
           let surnameTextField = surnameTextField.text,
           let emailTextField = emailTextField.text,
           let passwordTextField = passwordTextField.text {
            Task {
                do {
                    try await UserRepository.shared.createAccount(
                        name: nameTextField,
                        email: emailTextField,
                        password: passwordTextField
                    )
                    UserRepository.shared.listener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
                        if let user = user,
                           let firebaseUserEmail = user.email {
                            UserRepository.shared.userReference = Firestore.firestore().collection("users").document(firebaseUserEmail)
                            UserRepository.shared.addNewUser(name: nameTextField, surname: surnameTextField, email: emailTextField)
                            self!.performSegue(withIdentifier: PerformSegueIdentifiers.segueToVCMain.rawValue, sender: nil)
                        } else {
                            self!.showAlert(message: "Firebase userReference error")
                        }
                    }
                } catch {
                    print("LogIn Error = \(error.localizedDescription)")
                    showAlert(message: error.localizedDescription)
                }
            }
        } else {
            showAlert(message: "Fill in the name, surnameTextField, email and password fields")
        }
    }

    @IBAction func signInButton(_ sender: Any) {
        // performSegue(withIdentifier: PerformSegueIdentifiers.segueToVCSignIn.rawValue, sender: nil)
        dismiss(animated: true)
    }

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func showAlert(message: String) {
        let alert = UIAlertController(
          title: message,
          message: nil,
          preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil ))
        self.present(alert, animated: true, completion: nil)
    }

}
