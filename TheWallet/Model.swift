//
//  Model.swift
//  MoneyManager
//
//  Created by Roman on 26.01.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

// enum SignInMethod {
//   case email
//   case apple
//   case google
// }

enum ReusableCellIdentifier: String {
    case operation
    case header
    case cellCategory
    case cellDate
    case cellNote
    case cellNewCategory
    case cellChangeCategory
}

enum PerformSegueIdentifiers: String {
    case segueToVCSignIn
    case segueToVCMain
    case segueToVCAccount
    case segueToVCSetting
    case segueToVCSettingForEdit
    case segueToVCGraph
    case segueToVCOperation
}

enum ThrowError: Error {
    case getUserDataError
    case getUserReferenceError
    case emptyInputFields
    case customError(errorName: String)
    case newOperationCategoryError
    // VCGraph errors
    case calculateDateArrayFreshHoldDateError
    case calculateDateArrayError
    case calculateCumulativeAmountError
    case vcGraphDataUpdate
    case mainViewUpdateScreen
    case showOperation
    case hideOperation
    case vcSettingGetUserDataError
    // MainVM+TableExtension
    case applySnapshot
    // SettingViewModel
    case returnDelegateScreen2TableViewCellNote
    case changeCategoryOpenPopUpScreen2
    case changeCategoryClosePopUpScreen2
    // CategoryViewModel
    case vcCategoryReturnVCMainDelegate
    case vcCategoryReturnDelegateScreen2ContainerTableVCNewCategory
    case vcCategorygetVCSettingDelegate
    // CategoryTableVCCategory
    case categoryTableVCCategoryReturnCategryIdOfCell
    case categoryTableVCCategoryCloseEditing
}

typealias NestedType = (User) -> Void

struct GraphData {
    let date: Date
    let amount: Double
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

final class UserRepository {
    static let shared = UserRepository()
    var user: User?
    var mainDiffableSections: [String] = []
    var mainDiffableSectionsSource: [String: [Operation]] = [:]
    let documentReference = Firestore.firestore().collection("users")
    var userReference: DocumentReference?
    var signInMethod: String?

    let auth = Auth.auth()
    var listener: AuthStateDidChangeListenerHandle?
}
