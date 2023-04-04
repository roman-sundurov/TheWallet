//
//  DataManager.swift
//  TheWallet
//
//  Created by Roman on 30.03.2023.
//

import Foundation

final class DataManager {
    static let shared = DataManager()

    private var userRepository = UserRepository.shared

    var income: Double = 0
    var expensive: Double = 0
    var operationForEditing: Operation? = nil

    func countingIncomesAndExpensive() throws {
        if let operations = dataManager.getUserRepository().user?.operations,
        let userRepositoryUser = dataManager.getUserRepository().user {
            let freshHold = Date().timeIntervalSince1970 - Double(86400 * userRepositoryUser.daysForSorting)

            income = 0
            expensive = 0
            for data in operations.filter({ $0.value.amount > 0 && $0.value.date > freshHold }) {
                income += data.value.amount
            }
            for data in operations.filter({ $0.value.amount < 0 && $0.value.date > freshHold }) {
                expensive += data.value.amount
            }
        } else {
            throw ThrowError.countingIncomesAndExpensiveError
            // showAlert(message: "Error countingIncomesAndExpensive")
        }
    }

    func getUserRepository() -> UserRepository {
        return userRepository
    }

    func getUserData() throws -> User {
        if let userRepositoryUser = userRepository.user {
            return userRepositoryUser
        } else {
            throw ThrowError.getUserDataError
        }
    }

    func fetchFirebase(inner: @escaping () -> Void) async throws {
        try await userRepository.fetchUserData { user in
            dataManager.userRepository.user = user
            print("fetchFirebase= \(String(describing: dataManager.userRepository.user))")
            inner()
        }
    }

    func updateOperations(amount: Double, categoryUUID: UUID, note: String, date: Date, idOfObject: UUID) throws {
        try userRepository.updateOperations(
            amount: amount,
            categoryUUID: categoryUUID,
            note: note,
            date: date,
            idOfObject: idOfObject
        )
    }

    func addOperations(amount: Double, categoryUUID: UUID, note: String, date: Date) throws {
        try userRepository.addOperations(amount: amount, categoryUUID: categoryUUID, note: note, date: date)
    }

    func deleteCategory(idOfObject: UUID) throws {
        try userRepository.deleteCategory(idOfObject: idOfObject)
    }

    func updateCategory(name: String, icon: String, idOfObject: UUID) throws {
        try userRepository.updateCategory(name: name, icon: icon, idOfObject: idOfObject)
    }

    func addCategory(name: String, icon: String, date: Double) throws {
        try userRepository.addCategory(name: name, icon: icon, date: date)
    }

    func deleteOperation(uuid: UUID, inner: @escaping () -> Void) throws {
        try userRepository.deleteOperation(idOfObject: uuid) {
            inner()
        }
    }

}
