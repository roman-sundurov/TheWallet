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

    @IBOutlet var scrollViewBottomConstraint: NSLayoutConstraint!
    var keyboardHeight: CGFloat = 0 // хранит высоту клавиатуры
    var tapOutsideTextViews: UITapGestureRecognizer?

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
                            UserRepository.shared.addNewUser(
                                name: nameTextField,
                                surname: surnameTextField,
                                email: emailTextField
                            )
                            self!.performSegue(withIdentifier: SegueIdentifiers.segueToVCRootController.rawValue, sender: nil)
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
        dismiss(animated: true)
    }

    // MARK: - lifecycle
    override func viewWillAppear(_ animated: Bool) {

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
            // showAlert(message: "Error addGestureRecognizer")
            print("Error: VCSignIn addGestureRecognizer")
        }

        nameTextField.delegate = self
        nameTextField.inputAccessoryView = createDoneButton()

        surnameTextField.delegate = self
        surnameTextField.inputAccessoryView = createDoneButton()

        emailTextField.delegate = self
        emailTextField.inputAccessoryView = createDoneButton()

        passwordTextField.delegate = self
        passwordTextField.inputAccessoryView = createDoneButton()

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

    // MARK: - keyboard avioding
    @objc func tapHandler(tap: UITapGestureRecognizer) {
        if tap.state == UIGestureRecognizer.State.ended {
            print("Tap TextView ended")
            let pointOfTap = tap.location(in: self.view)
            if !nameTextField.frame.contains(pointOfTap) && !surnameTextField.frame.contains(pointOfTap) &&
                !emailTextField.frame.contains(pointOfTap) &&
                !passwordTextField.frame.contains(pointOfTap) {

                nameTextField.endEditing(true)
                surnameTextField.endEditing(true)
                emailTextField.endEditing(true)
                passwordTextField.endEditing(true)
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

extension VCSignUp: UITextFieldDelegate {
    func createDoneButton() -> UIView {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default

        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
            target: nil,
            action: nil
        )
        let done: UIBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: UIBarButtonItem.Style.done,
            target: self,
            action: #selector(self.doneButtonAction)
        )

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        return doneToolbar
    }

    @objc func doneButtonAction() {
        nameTextField.resignFirstResponder()
        surnameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

}
