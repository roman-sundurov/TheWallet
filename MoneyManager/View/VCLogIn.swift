//
//  VCLogIn.swift
//  MoneyManager
//
//  Created by Roman on 21.11.2022.
//

import UIKit

class VCLogIn: UIViewController {

  @IBOutlet var logInButton: UIButton!

  @IBOutlet var emailTextField: UITextField!
  @IBOutlet var passwordTextField: UITextField!

  @IBAction func logInButton(_ sender: Any) {
    Task {
      do {
        try await UserRepository.shared.signIn(email: emailTextField.text!, password: passwordTextField.text!)
        performSegue(withIdentifier: "segueToVCMain", sender: nil)
      } catch {
        print("LogIn Error = \(error)")
      }
    }
  }


  override func viewDidLoad() {
        super.viewDidLoad()

    }

}
