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

    func fetchUserData(inner: @escaping NestedType) async throws {
        if let userReference = UserRepository.shared.userReference {
            userReference.getDocument { (document, _) in
                if let document = document,
                   !document.exists,
                   let emailUD = UserDefaults.standard.object(forKey: "email") as? String {
                    UserRepository.shared.addNewUser(name: "", surname: "", email: emailUD)
                }
                if let document = document, document.exists,
                   let userData = try? document.data(as: User.self) {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("fetchGetUserData Document data: \(dataDescription)")
                    inner(userData)
                } else {
                    print("fetchGetUserData Document does not exist")
                }
            }
        } else {
            throw ThrowError.fetchUserDataError
        }
    }

    func addNewUser(name: String, surname: String, email: String) {
        let newUser = User(
            name: name,
            surname: surname,
            email: email,
            categories: [:],
            operations: [:]
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

    func updateDaysForSorting(daysForSorting: Int) throws {
        user?.daysForSorting = daysForSorting
        if let userReference = userReference {
            userReference.setData([
                "daysForSorting": daysForSorting
            ], merge: true) { error in
                if let error = error {
                    print("updateDaysForSorting Error writing document: \(error)")
                } else {
                    print("updateDaysForSorting Document successfully written!")
                }
            }
        } else {
            throw ThrowError.getUserReferenceError
        }
    }

    // MARK: - categories
    func addCategory(name: String, icon: String, date: Double) throws {
        let newCategory = Category(name: name, icon: icon, date: date, id: UUID())
        user?.categories[newCategory.id.description] = newCategory
        if let userReference = userReference {
            userReference.setData([
                "categories": [
                    newCategory.id.description: [
                        "name": newCategory.name,
                        "icon": newCategory.icon,
                        "date": date,
                        "id": newCategory.id.description
                    ] as [String: Any]
                ]
            ], merge: true) { error in
                if let error = error {
                    print("addCategory Error writing document: \(error)")
                } else {
                    print("addCategory Document successfully written!")
                }
            }
        } else {
            throw ThrowError.getUserReferenceError
        }
    }

    func deleteCategory(idOfObject: UUID) throws {
        user?.categories[idOfObject.description] = nil
        if let userReference = userReference {
            userReference.updateData([
                "categories.\(idOfObject.description)": FieldValue.delete()
            ]) { error in
                if let error = error {
                    print("deleteCategory Error writing document: \(error)")
                } else {
                    print("deleteCategory Document successfully written!")
                }
            }
        } else {
            throw ThrowError.getUserReferenceError
        }
    }

    func updateCategory(name: String, icon: String, idOfObject: UUID) throws {
        if var category = user?.categories[idOfObject.description] {
            category.name = name
            category.icon = icon
            user?.categories[idOfObject.description] = category
        } else {
            throw ThrowError.updateCategoryError
        }
        if let userReference = userReference {
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
        } else {
            throw ThrowError.getUserReferenceError
        }
    }

    // MARK: - operations
    func deleteOperation(idOfObject: UUID, inner: @escaping () -> Void) throws {
        UserRepository.shared.user?.operations[idOfObject.description] = nil
        if let userReference = userReference {
            userReference.updateData([
                "operations.\(idOfObject.description)": FieldValue.delete()
            ]) { error in
                if let error = error {
                    print("deleteOperation Error writing document: \(error)")
                } else {
                    print("deleteOperation Document successfully written!")
                }
                inner()
            }
        } else {
            throw ThrowError.getUserReferenceError
        }
    }

    func addOperations(amount: Double, categoryUUID: UUID, note: String, date: Date) throws {
        let newOperation = Operation(
            amount: amount,
            category: categoryUUID,
            note: note,
            date: date.timeIntervalSince1970
        )
        UserRepository.shared.user?.operations[categoryUUID.description] = newOperation
        if let userReference = userReference {
            if let newOperationCategory = newOperation.category {
                userReference.setData([
                    "operations": [
                        newOperation.id.description: [
                            "amount": newOperation.amount,
                            "category": newOperationCategory.description,
                            "note": newOperation.note,
                            "date": newOperation.date,
                            "id": newOperation.id.description
                        ] as [String: Any]
                    ]
                ], merge: true) { error in
                    if let error = error {
                        print("addCategory Error writing document: \(error)")
                    } else {
                        print("addCategory Document successfully written!")
                    }
                }
            } else {
                throw ThrowError.newOperationCategoryError
            }
        } else {
            throw ThrowError.getUserReferenceError
        }
    }

    func updateOperations(amount: Double, categoryUUID: UUID, note: String, date: Date, idOfObject: UUID) throws {
        let updOperation = Operation(
            amount: amount,
            category: categoryUUID,
            note: note,
            date: date.timeIntervalSince1970,
            id: idOfObject
        )
        print("idOfObject= \(idOfObject)")
        UserRepository.shared.user?.operations[idOfObject.description] = updOperation
        if let userReference = userReference {
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
        } else {
            throw ThrowError.getUserReferenceError
        }
    }

}
