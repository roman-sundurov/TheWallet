//
//  Firebase.swift
//  MoneyManager
//
//  Created by Roman on 28.10.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

extension UserRepository {

  func getUserData(inner: @escaping NestedType) async throws {
    userReference.getDocument { (document, _) in
      if let document = document, document.exists {
        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
        print("getUserData Document data: \(dataDescription)")
        print("getUserData aaa")
        let userData = try? document.data(as: User.self)
        inner(userData!)
        print("getUserData bbb")
      } else {
        print("getUserData Document does not exist")
      }
    }
  }

  func addNewUser(name: String, surname: String, email: String) {
    let newCategory = Category(name: "newCategory", icon: "", date: 1666209106, id: UUID())
    let newOperation = Operation(amount: 100, category: newCategory.id, note: "Test note", date: 1666209105, id: UUID())
    let newUser = User(
      name: name,
      surname: surname,
      email: email,
      categories: [newCategory.date.description: newCategory],
      operations: [newOperation.date.description: newOperation]
    )
    try? documentReference.document(email).setData(from: newUser) { error in
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
    userReference.setData([
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
    UserRepository.shared.user?.daysForSorting = daysForSorting
    userReference.setData([
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
    UserRepository.shared.user?.categories[idOfObject.description] = nil
    userReference.updateData([
      "categories.\(idOfObject.description)": FieldValue.delete()
    ]) { error in
      if let error = error {
        print("deleteCategory Error writing document: \(error)")
      } else {
        print("deleteCategory Document successfully written!")
      }
    }
  }

  func deleteOperation(idOfObject: UUID) {
    UserRepository.shared.user?.operations[idOfObject.description] = nil
    userReference.updateData([
      "operations.\(idOfObject.description)": FieldValue.delete()
    ]) { error in
      if let error = error {
        print("deleteOperation Error writing document: \(error)")
      } else {
        print("deleteOperation Document successfully written!")
      }
    }

  }

  func updateCategory(name: String, icon: String, idOfObject: UUID) {
    userReference.updateData([
      "categories.\(idOfObject).name": name,
      "categories.\(idOfObject).icon": icon
    ]) { error in
      if let error = error {
        print("updateCategory Error writing document: \(error)")
      } else {
        print("updateCategory Document successfully written!")
      }
    }
  }

  // MARK: - operations
  func addOperations(amount: Double, categoryUUID: UUID, note: String, date: Date) {
    let newOperation = Operation(amount: amount, category: categoryUUID, note: note, date: date.timeIntervalSince1970)
    UserRepository.shared.user?.operations[categoryUUID.description] = newOperation
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
    let updOperation = Operation(
      amount: amount,
      category: categoryUUID,
      note: note,
      date: date.timeIntervalSince1970,
      id: idOfObject
    )
    print("idOfObject= \(idOfObject)")
    UserRepository.shared.user?.operations[idOfObject.description] = updOperation
    userReference.updateData([
      "operations.\(idOfObject.description).amount": amount,
      "operations.\(idOfObject.description).category": categoryUUID.description,
      "operations.\(idOfObject.description).note": note,
      "operations.\(idOfObject.description).date": date.timeIntervalSince1970
    ]) { error in
      if let error = error {
        print("addCategory Error writing document: \(error)")
      } else {
        print("addCategory Document successfully written!")
      }
    }
  }

}
