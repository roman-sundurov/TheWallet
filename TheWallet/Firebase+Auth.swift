//
//  Firebase+Auth.swift
//  MoneyManager
//
//  Created by Roman on 21.11.2022.
//

import FirebaseAuth

extension UserRepository {

  func signIn(email: String, password: String) async throws {
      try await Auth.auth().signIn(withEmail: email, password: password)
  }

  func createAccount(name: String, email: String, password: String) async throws {
    let result = try await Auth.auth().createUser(withEmail: email, password: password)
  }
  
}
