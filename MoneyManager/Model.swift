//
//  Model.swift
//  MoneyManager
//
//  Created by Roman on 26.01.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum ErrorTypes: Error {
  case cellError
  case  modelError
}

typealias NestedType = (User) -> Void

struct GraphData {
  var date: Date
  var amount: Double
}

struct Operation: Codable, Identifiable, Equatable, Hashable {
  var amount: Double
  var category: UUID?
  var note: String
  var date: Double
  var id = UUID()
}

struct Category: Codable, Identifiable, Equatable, Hashable {
  var name: String = ""
  var icon: String = ""
  var date: Double = 0
  var id = UUID()
}

struct User: Codable, Identifiable, Equatable, Hashable {
  static func == (lhs: User, rhs: User) -> Bool {
    lhs.id == rhs.id
  }

  var name: String = ""
  var surname: String = ""
  var email: String = ""
  var daysForSorting: Int = 30
  var lastIdOfOperations: Int = -1
  var lastIdOfCategories: Int = -1
  var categories: [String: Category] = [:]
  var operations: [String: Operation] = [:]
  var id = UUID()
}

class UserRepository {
  static let shared = UserRepository()
  var user: User?
  var mainDiffableSections: [String] = []
  var mainDiffableSectionsSource: [String: [Operation]] = [:]
  let documentReference = Firestore.firestore().collection("users")
  var userReference = Firestore.firestore().collection("users").document("roman.sundurov.work@gmail.com")
}
