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
    
    @IBAction func logOut(_ sender: Any) {
        UserRepository.shared.logOut()
        performSegue(withIdentifier: "segueToVCSignIn", sender: nil)
    }
    
    @IBAction func closeView(_ sender: Any) {
        dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
