//
//  vmMain.swift
//  MoneyManager
//
//  Created by Roman on 27.04.2022.
//

import Foundation
import UIKit

extension VCMain: ProtocolVCMain {

    func hudAppear() {

        hud.show(in: bottomPopInView)
        buttonShowList.isEnabled = false
        buttonShowGraph.isEnabled = false
        buttonNewOperation.isEnabled = false
        print("hudAppear")
    }

    func hudDisapper() {
        hud.dismiss(animated: true)
        buttonShowList.isEnabled = true
        buttonShowGraph.isEnabled = true
        buttonNewOperation.isEnabled = true
        isButtonsActive = true
        print("hudDisapper")
    }

    func fetchFirebase() async {
        Task {
            do {
                try await userRepository.fetchGetUserData { user in
                    self.userRepository.user = user
                    print("NewData= \(String(describing: self.userRepository.user))")
                    do {
                        try self.updateScreen()
                    } catch {
                        self.showAlert(message: "Screen update error")
                    }
                }
            } catch ThrowError.getUserDataError {
                showAlert(message: "Database connection error, missing userReference")
            }
        }
    }

    func updateUserData(newData: User) {
        userRepository.user = newData
    }

    func updateOperations(amount: Double, categoryUUID: UUID, note: String, date: Date, idOfObject: UUID) {
        userRepository.updateOperations(
            amount: amount,
            categoryUUID: categoryUUID,
            note: note,
            date: date,
            idOfObject: idOfObject
        )
        do {
            try updateScreen()
        } catch {
            showAlert(message: "Screen update error")
        }
    }

    func addOperations(amount: Double, categoryUUID: UUID, note: String, date: Date) {
        do {
            try userRepository.addOperations(amount: amount, categoryUUID: categoryUUID, note: note, date: date)
        } catch ThrowError.getUserReferenceError {
            showAlert(message: "Database connection error, missing userReference")
        } catch {
            showAlert(message: "Database connection error")
        }
        do {
            try updateScreen()
        } catch {
            showAlert(message: "Screen update error")
        }
    }

    func deleteCategory(idOfObject: UUID) {
        do {
            try userRepository.deleteCategory(idOfObject: idOfObject)
        } catch ThrowError.getUserReferenceError {
            showAlert(message: "Database connection error, missing userReference")
        } catch {
            showAlert(message: "Database connection error")
        }
    }

    func updateCategory(name: String, icon: String, idOfObject: UUID) {
        do {
            try userRepository.updateCategory(name: name, icon: icon, idOfObject: idOfObject)
        } catch ThrowError.getUserReferenceError {
            showAlert(message: "Database connection error, missing userReference")
        } catch {
            showAlert(message: "Database connection error")
        }
    }

    func addCategory(name: String, icon: String, date: Double) {
        do {
            try userRepository.addCategory(name: name, icon: icon, date: date)
        } catch ThrowError.getUserDataError {
            showAlert(message: "Database connection error, missing userReference")
        } catch {
            showAlert(message: "Database connection error")
        }
    }

    func deleteOperation(uuid: UUID) {
        do {
            try userRepository.deleteOperation(idOfObject: uuid)
        } catch ThrowError.getUserDataError {
            showAlert(message: "Database connection error, missing userReference")
        } catch {
            showAlert(message: "Database connection error")
        }
        do {
            try updateScreen()
        } catch {
            showAlert(message: "Screen update error")
        }
    }

    func miniGraphStarterBackground(status: Bool) {
        miniGraphStarterBackground.isHidden = status
    }

    func returnIncomesExpenses() -> [String: Double]? {
        if income != 0 || expensive != 0 {
            print("income= \(income), expensive= \(expensive)")
            return ["income": income, "expensive": expensive]
        } else {
            return nil
        }
    }

    func returnMonthOfDate(_ dateInternal: Date) -> String {
        let formatterPrint = DateFormatter()
        formatterPrint.timeZone = TimeZone(secondsFromGMT: 10800) // +3 час(Moscow)
        formatterPrint.dateFormat = "MMMM YYYY"
        return formatterPrint.string(from: dateInternal)
    }

    func editOperation(uuid: UUID) {
        do {
            try hideOperation()
        } catch {
            showAlert(message: "hideOperation error")
        }
        tagForEdit = uuid
        performSegue(withIdentifier: PerformSegueIdentifiers.segueToVCSettingForEdit.rawValue, sender: nil)
    }

    func updateScreen() throws {
        if let userRepositoryUser = userRepository.user {
            print("UpdateScreen daysForSorting= \(userRepositoryUser.daysForSorting)")
            borderLineForMenu(days: userRepositoryUser.daysForSorting)
            countingIncomesAndExpensive()
            do {
                try vcGraphDelegate?.dataUpdate()
                miniGraph.setNeedsDisplay()
                configureDataSource()
                try applySnapshot()
            } catch {
                showAlert(message: "Error updating VCGraph")
            }
        } else {
            throw ThrowError.mainViewUpdateScreen
        }
    }

    func findAmountOfHeaders() {
        return
    }

    // MARK: - PopUp-окно операции
    func showOperation(_ id: UUID) throws {
        viewOperation.layer.cornerRadius = 20
        vcOperationDelegate?.prepareForStart(id: id)
        self.tapShowOperation = UITapGestureRecognizer(
            target: self,
            action: #selector(self.handlerToHideContainerScreen1(tap:)))
        if let tapShowOperation = self.tapShowOperation {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: UIView.AnimationOptions(),
            animations: {
                self.constraintContainerBottomPoint.constant = 50
                self.view.addGestureRecognizer(tapShowOperation)
                self.blurView.isHidden = false
                self.view.layoutIfNeeded()
            },
            completion: { _ in })
        } else {
            throw ThrowError.showOperation
        }
    }

    func hideOperation() throws {
        if let tapShowOperation = self.tapShowOperation {
        UIView.animate(
            withDuration: 0,
            delay: 0,
            usingSpringWithDamping: 0,
            initialSpringVelocity: 0,
            options: UIView.AnimationOptions(),
            animations: {
                self.constraintContainerBottomPoint.constant = -311
                self.blurView.isHidden = true
                self.view.removeGestureRecognizer(tapShowOperation)
                self.view.layoutIfNeeded()
            },
            completion: { _ in })
        } else {
            throw ThrowError.hideOperation
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

    func returnDayOfDate(_ dateInternal: Date) -> String {
        let formatterPrint = DateFormatter()
        formatterPrint.timeZone = TimeZone(secondsFromGMT: 10800) // +3 час(Moscow)
        if let userRepositoryUser = userRepository.user {
            switch userRepositoryUser.daysForSorting {
            case 365:
                formatterPrint.dateFormat = "MMMM YYYY"
            default:
                formatterPrint.dateFormat = "d MMMM YYYY"
            }
        } else {
            formatterPrint.dateFormat = "d MMMM YYYY"
        }
        return formatterPrint.string(from: dateInternal)
    }

    func returnGraphData() -> [GraphData] {
        return graphDataArray
    }
}
