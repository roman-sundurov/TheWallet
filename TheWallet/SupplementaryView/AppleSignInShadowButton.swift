//
//  AppleSignInShadowButton.swift
//  TheWallet
//
//  Created by Roman on 02.01.2023.
//

import UIKit
import FirebaseAuth

  // Apple SignIn
import AuthenticationServices
import CryptoKit

// @IBDesignable
final class AppleSignInShadowButton: ASAuthorizationAppleIDButton {

  var currentNonce: String?

  override init(
    authorizationButtonType type: ASAuthorizationAppleIDButton.ButtonType,
    authorizationButtonStyle style: ASAuthorizationAppleIDButton.Style
  ) {
    super.init(authorizationButtonType: type, authorizationButtonStyle: style)
    viewSetup()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    viewSetup()
  }

  func viewSetup() {
    self.layer.shadowOpacity = 1
    self.layer.shadowOffset = CGSize(width: 8.33, height: 8.33)
    self.layer.shadowRadius = 12
    self.layer.shadowColor = UIColor(red: 0.008, green: 0.008, blue: 0.275, alpha: 0.1).cgColor

    // self.layer.borderWidth = 2
    // self.layer.borderColor = UIColor(red: 0.937, green: 0.941, blue: 0.969, alpha: 1).cgColor
    self.layer.cornerRadius = 10
    self.clipsToBounds = true

    let gesture = UITapGestureRecognizer(
          target: self,
          action: #selector(self.appleSignInTapped(tap:))
      )
      self.addGestureRecognizer(gesture)

    // self.addTarget(self, action: #selector(appleSignInTapped), for: .touchUpInside)
  }

    @objc func appleSignInTapped(tap: UITapGestureRecognizer) {
        print("AppleSignInTouch")
        if tap.state == UIGestureRecognizer.State.ended {

            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            // request full name and email from the user's Apple ID
            request.requestedScopes = [.fullName, .email]

            // Generate nonce for validation after authentication successful
            self.currentNonce = randomNonceString()
            // Set the SHA256 hashed nonce to ASAuthorizationAppleIDRequest
            request.nonce = sha256(currentNonce!)

            // pass the request to the initializer of the controller
            let authController = ASAuthorizationController(authorizationRequests: [request])

            // similar to delegate, this will ask the view controller
            // which window to present the ASAuthorizationController
            authController.presentationContextProvider = self

            // delegate functions will be called when user data is
            // successfully retrieved or error occured
            authController.delegate = self

            // show the Sign-in with Apple dialog
            authController.performRequests()
        }
    }
}

extension AppleSignInShadowButton: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.window!
  }
}

extension AppleSignInShadowButton: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("authorization error")
        guard let error = error as? ASAuthorizationError else {
            return
        }

        switch error.code {
        case .canceled:
                // user press "cancel" during the login prompt
            print("Canceled")
        case .unknown:
                // user didn't login their Apple ID on the device
            print("Unknown")
        case .invalidResponse:
                // invalid response received from the login
            print("Invalid Respone")
        case .notHandled:
                // authorization request not handled, maybe internet failure during login
            print("Not handled")
        case .failed:
                // authorization failed
            print("Failed")
        case .notInteractive:
            print("Default")
        @unknown default:
            print("Default")
        }
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }

    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {

        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // unique ID for each user, this uniqueID will always be returned
            // let userID = appleIDCredential.user
            UserDefaults.standard.set(appleIDCredential.user, forKey: "appleAuthorizedUserIdKey")

            // Retrieve the secure nonce generated during Apple sign in
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            // Retrieve Apple identity token
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Failed to fetch identity token")
                return
            }
            // Convert Apple identity token to string
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Failed to decode identity token")
                return
            }
            // Initialize a Firebase credential using secure nonce and Apple identity token
            let firebaseCredential = OAuthProvider.credential(withProviderID: "apple.com",
                                                              idToken: idTokenString,
                                                              rawNonce: nonce)
            Auth.auth().signIn(with: firebaseCredential) { [weak self] (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }

            // optional, might be nil
            // let email = appleIDCredential.email
            // let givenName = appleIDCredential.fullName?.givenName
            // let familyName = appleIDCredential.fullName?.familyName
            // let nickName = appleIDCredential.fullName?.nickname

        }
    }

}
