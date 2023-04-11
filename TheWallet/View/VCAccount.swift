//
//  VCAccount.swift
//  MoneyManager
//
//  Created by Roman on 22.11.2022.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class VCAccount: UIViewController {

    @IBOutlet var logOut: UIButton!

    @IBAction func logOutAction(_ sender: Any) {
        dataManager.getUserRepository().logOut()
        // UserRepository.shared.logOut()
        performSegue(withIdentifier: SegueIdentifiers.segueToVCSignIn.rawValue, sender: nil)
    }

    @IBAction func closeView(_ sender: Any) {
        dismiss(animated: true)
    }

    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        logOut.layer.cornerRadius = 10
    }
}
