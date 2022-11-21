//
//  Firebase+Auth.swift
//  MoneyManager
//
//  Created by Roman on 21.11.2022.
//

import Foundation
import FirebaseAuth

extension UserRepository {

  func signIn(email: String, password: String) async throws {
      try await auth.signIn(withEmail: email, password: password)
  }
  
}
