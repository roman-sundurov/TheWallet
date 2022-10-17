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

struct Operation: Codable, Identifiable {
  var amount: Double
  var category: String
  var note: String
  var date: Date
  var id = UUID()
}

struct Category: Codable, Identifiable, Equatable {
  var name: String = ""
  var icon: String = ""
  var id = UUID()
}

struct User: Codable, Identifiable, Equatable {
  static func == (lhs: User, rhs: User) -> Bool {
    lhs.id == rhs.id
  }

  static let shared = User()

  var name: String = ""
  var surname: String = ""
  var email: String = ""
  var daysForSorting: Int = 30
  var lastIdOfOperations: Int = -1
  var lastIdOfCategories: Int = -1
  var categories: [Category] = []
  var operations: [Operation] = []
  var id = UUID()
}

struct UserRepository {
  var user: User?
  let documentReference = Firestore.firestore().collection("users")
  let userReference = Firestore.firestore().collection("users").document("9Nxk6SZmNr3o9ld5VZj1")

  func getUserData(inner: @escaping nestedType) async throws {
    userReference.getDocument { (document, error) in
      if let document = document, document.exists {
        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
        print("Document data: \(dataDescription)")
        print("aaa")
          // if let user = try? document.data(as: User.self) {
        self.userData = try! document.data(as: User.self)
        inner(self.userData!)
        print("bbb")
          // }
      } else {
        print("Document does not exist")
      }
    }
  }

  func addNewUser(name: String, surname: String, email: String) {

    let newUser = User(name: name, surname: surname, email: email, categories: [], operations: [])
    try! documentReference.document(email).setData(from: newUser) { error in
      if let error = error {
        print("addNewUser Error writing document: \(error)")
      } else {
        print("addNewUser Document successfully written!")
      }
    }
  }

  func addCategory(name: String, icon: String) {
    let newCategory = Category(name: name, icon: icon, id: UUID())
    try! userReference .setData([
      "categories": [
        newCategory.id.description: [
          "name": newCategory.name,
          "icon": newCategory.icon,
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
    try! userReference .setData([
      "daysForSorting": daysForSorting
    ], merge: true) { error in
      if let error = error {
        print("updateDaysForSorting Error writing document: \(error)")
      } else {
        print("updateDaysForSorting Document successfully written!")
      }
    }
  }

  func deleteCategory(idOfObject: Int) {
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

  func deleteOperation(idOfObject: Int) {
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
  func addOperations(amount: Double, category: String, note: String, date: Date) {
    let newOperation = Operation(amount: amount, category: category, note: note, date: date)
    userReference .setData([
      "operations": [
        newOperation.id.description: [
          "amount": newOperation.amount,
          "category": newOperation.category,
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


  func updateOperations(amount: Double, category: String, note: String, date: Date, idOfObject: UUID) {
    let updOperation = Operation(amount: amount, category: category, note: note, date: date)
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
