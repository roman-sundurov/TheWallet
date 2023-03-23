//
//  Firebase+Auth.swift
//  MoneyManager
//
//  Created by Roman on 21.11.2022.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

extension UserRepository {

    func signIn(email: String, password: String) async throws {
        try await Auth.auth().signIn(withEmail: email, password: password)
    }

    func createAccount(name: String, email: String, password: String) async throws {
        try await Auth.auth().createUser(withEmail: email, password: password)
    }

    func logOut() {
        print("signInMethod= \(String(describing: UserRepository.shared.signInMethod))")
        let provider = Auth.auth().currentUser?.providerData.first?.providerID
        Auth.auth().currentUser?.providerData.map { provider in
            print("switch provider= \(provider.providerID)")
            switch provider.providerID {
            case "password":
                    // try? Auth.auth().signOut()
                UserRepository.shared.user = nil
                let defaults = UserDefaults.standard
                defaults.removeObject(forKey: "email")
                defaults.removeObject(forKey: "password")

            case "google.com":
                GIDSignIn.sharedInstance.signOut()

            case "facebook.com":
                let loginManager = LoginManager()
                loginManager.logOut()

                let defaults = UserDefaults.standard
                defaults.removeObject(forKey: "facebookToken")

            case "apple.com":
                UserDefaults.standard.set(nil, forKey: "appleAuthorizedUserIdKey")
            default:
                print("not logOut data")
            }

            try? Auth.auth().signOut()
            UserRepository.shared.user = nil
                // let defaults = U-serDefaults.standard
        }
    }
}
