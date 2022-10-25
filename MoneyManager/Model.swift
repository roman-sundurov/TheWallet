//
//  Model.swift
//  MoneyManager
//
//  Created by Roman on 26.01.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

typealias nestedType = (User) -> Void

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
  // var semaphore = DispatchSemaphore(value: 0)

  let documentReference = Firestore.firestore().collection("users")
  var userReference = Firestore.firestore().collection("users").document("roman.sundurov.work@gmail.com")

  func getUserData(inner: @escaping nestedType) async throws {
    userReference.getDocument { (document, error) in
      if let document = document, document.exists {
        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
        print("getUserData Document data: \(dataDescription)")
        print("getUserData aaa")
        let userData = try! document.data(as: User.self)
        inner(userData)
        print("getUserData bbb")
        // semaphore.signal()
          // }
      } else {
        print("getUserData Document does not exist")
      }
    }
  }

  func addNewUser(name: String, surname: String, email: String) {

    let newCategory = Category(name: "newCategory", icon: "", date: 1666209106, id: UUID())
    let newOperation = Operation(amount: 100, category: newCategory.id, note: "Test note", date: 1666209105, id: UUID())

    let newUser = User(name: name, surname: surname, email: email, categories: [newCategory.date.description: newCategory], operations: [newOperation.date.description: newOperation])
    try! documentReference.document(email).setData(from: newUser) { error in
      if let error = error {
        print("addNewUser Error writing document: \(error)")
      } else {
        print("addNewUser Document successfully written!")
      }
    }
    user = newUser
  }

  func addCategory(name: String, icon: String, date: Double) {
    let newCategory = Category(name: name, icon: icon, date: date, id: UUID())
    UserRepository.shared.user?.categories[newCategory.id.description] = newCategory
    try! userReference.setData([
      "categories": [
        newCategory.id.description: [
          "name": newCategory.name,
          "icon": newCategory.icon,
          "date": date,
          "id": newCategory.id.description
        ]
      ]
    ], merge: true) { error in
      if let error = error {
        print("addCategory Error writing document: \(error)")
      } else {
        print("addCategory Document successfully written!")
      }
    }
  }

  func updateDaysForSorting(daysForSorting: Int) {
    try! userReference.setData([
      "daysForSorting": daysForSorting
    ], merge: true) { error in
      if let error = error {
        print("updateDaysForSorting Error writing document: \(error)")
      } else {
        print("updateDaysForSorting Document successfully written!")
      }
    }
  }

  func deleteCategory(idOfObject: UUID) {
    userReference.updateData([
      "categories": [
        idOfObject.description: FieldValue.delete()
      ]
    ]) { error in
      if let error = error {
        print("deleteCategory Error writing document: \(error)")
      } else {
        print("deleteCategory Document successfully written!")
      }
    }
  }

  func deleteOperation(idOfObject: UUID) {
    userReference.updateData([
      "operations": [
        idOfObject.description: FieldValue.delete()
      ]
    ]) { error in
      if let error = error {
        print("deleteOperation Error writing document: \(error)")
      } else {
        print("deleteOperation Document successfully written!")
      }
    }

  }

  func updateCategory(name: String, icon: String, idOfObject: UUID) {
    let updCategory = Category(name: name, icon: icon, id: idOfObject)
    userReference.setData([
      "categories": [
        idOfObject.description: [
          "name": updCategory.name,
          "icon": updCategory.icon
          // "id": updCategory.id.description
        ]
      ]
    ], merge: true) { error in
      if let error = error {
        print("updateCategory Error writing document: \(error)")
      } else {
        print("updateCategory Document successfully written!")
      }
    }
  }


    // MARK: - операции
  func addOperations(amount: Double, categoryUUID: UUID, note: String, date: Date) {
    let newOperation = Operation(amount: amount, category: categoryUUID, note: note, date: date.timeIntervalSince1970)
    UserRepository.shared.user?.operations[newOperation.id.description] = newOperation
    userReference.setData([
      "operations": [
        newOperation.id.description: [
          "amount": newOperation.amount,
          "category": newOperation.category!.description,
          "note": newOperation.note,
          "date": newOperation.date,
          "id": newOperation.id.description
        ]
      ]
    ], merge: true) { error in
      if let error = error {
        print("addCategory Error writing document: \(error)")
      } else {
        print("addCategory Document successfully written!")
      }
    }
  }


  func updateOperations(amount: Double, categoryUUID: UUID, note: String, date: Date, idOfObject: UUID) {
    let updOperation = Operation(amount: amount, category: categoryUUID, note: note, date: date.timeIntervalSince1970)
    userReference.setData([
      "operation": [
        idOfObject.description: [
          "amount": updOperation.amount,
          "category": updOperation.category,
          "note": updOperation.note,
          "date": updOperation.date
        ]
      ]
    ], merge: true) { error in
      if let error = error {
        print("addCategory Error writing document: \(error)")
      } else {
        print("addCategory Document successfully written!")
      }
    }
  }
}

class GraphData {
  var date: Date
  var amount: Double

  init(newDate: Date, newAmount: Double) {
    date = newDate
    amount = newAmount
  }
}
