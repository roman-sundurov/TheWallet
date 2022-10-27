//
//  vmMain.swift
//  MoneyManager
//
//  Created by Roman on 27.04.2022.
//

import Foundation
import UIKit

extension VCMain: protocolVCMain {

  func fetchFirebase() {
    Task {
      do {
        try? await userRepository.getUserData() { data in
          self.userRepository.user = data
          print("NewData= \(self.userRepository.user)")
          self.updateScreen()
        }
        print("NewData2= \(userRepository.user)")
      } catch {
        print("Error22")
      }
    }
  }

  func updateUserData(newData: User) {
    userRepository.user = newData
  }

  func updateOperations(amount: Double, categoryUUID: UUID, note: String, date: Date, idOfObject: UUID) {
    userRepository.updateOperations(amount: amount, categoryUUID: categoryUUID, note: note, date: date, idOfObject: idOfObject)
    updateScreen()
  }

  func addOperations(amount: Double, categoryUUID: UUID, note: String, date: Date) {
    userRepository.addOperations(amount: amount, categoryUUID: categoryUUID, note: note, date: date)
    updateScreen()
  }

  func deleteCategory(idOfObject: UUID) {
    userRepository.deleteCategory(idOfObject: idOfObject)
  }

  func updateCategory(name: String, icon: String, idOfObject: UUID) {
    userRepository.updateCategory(name: name, icon: icon, idOfObject: idOfObject)
  }

  func addCategory(name: String, icon: String, date: Double) {
    userRepository.addCategory(name: name, icon: icon, date: date)
  }

  func deleteOperation(uuid: UUID) {
    userRepository.deleteOperation(idOfObject: uuid)
    updateScreen()
  }

  func miniGraphStarterBackground(status: Bool) {
    miniGraphStarterBackground.isHidden = status
  }

  func returnIncomesExpenses() -> [String: Double] {
    if income != 0 || expensive != 0 {
      print("income= \(income), expensive= \(expensive)")
      return ["income": income, "expensive": expensive]
    } else {
      return [:]
    }
  }

  func returnMonthOfDate(_ dateInternal: Date) -> String {
    let formatterPrint = DateFormatter()
    formatterPrint.timeZone = TimeZone(secondsFromGMT: 10800) // +3 час(Moscow)
    formatterPrint.dateFormat = "MMMM YYYY"
    return formatterPrint.string(from: dateInternal)
  }

  func editOperation(uuid: UUID) {
    hideOperation()
    tagForEdit = uuid
    performSegue(withIdentifier: "segueToVCSettingForEdit", sender: nil)
  }


  func updateScreen() {
    borderLineForMenu(days: userRepository.user!.daysForSorting)
    countingIncomesAndExpensive()
    vcGraphDelegate?.dataUpdate()
    miniGraph.setNeedsDisplay()
    applySnapshot()
  }

  func findAmountOfHeaders() {
    return
  }

    // MARK: - PopUp-окно операции
  func showOperation(_ id: UUID) {
    viewOperation.layer.cornerRadius = 20
    vcOperationDelegate?.prepareForStart(id: id)

    UIView.animate(
      withDuration: 0.3,
      delay: 0,
      usingSpringWithDamping: 0.8,
      initialSpringVelocity: 0,
      options: UIView.AnimationOptions(),
      animations: {
        self.constraintContainerBottomPoint.constant = 50
        self.tapShowOperation = UITapGestureRecognizer(
          target: self,
          action: #selector(self.handlerToHideContainerScreen1(tap:)))
        self.view.addGestureRecognizer(self.tapShowOperation!)
        self.blurView.isHidden = false
        self.view.layoutIfNeeded()
      },
      completion: { _ in })
  }

  func hideOperation() {
    UIView.animate(
      withDuration: 0,
      delay: 0,
      usingSpringWithDamping: 0,
      initialSpringVelocity: 0,
      options: UIView.AnimationOptions(),
      animations: {
        self.constraintContainerBottomPoint.constant = -311
        self.blurView.isHidden = true
        self.view.removeGestureRecognizer(self.tapShowOperation!)
        self.view.layoutIfNeeded()
      },
      completion: { _ in })
  }

  func getUserRepository() -> UserRepository {
    return userRepository
  }

  func getUserData() -> User {
    return userRepository.user!
  }

  func returnDayOfDate(_ dateInternal: Date) -> String {
    let formatterPrint = DateFormatter()
    formatterPrint.timeZone = TimeZone(secondsFromGMT: 10800) // +3 час(Moscow)
    switch userRepository.user!.daysForSorting {
      case 365:
        formatterPrint.dateFormat = "MMMM YYYY"
      default:
        formatterPrint.dateFormat = "d MMMM YYYY"
    }
    return formatterPrint.string(from: dateInternal)
  }


    // MARK: - data calculating
  // func graphDataArrayCalculating(dataArrayOfOperationsInternal: [Operation]) {
  //     // Данные для передачи в график
  //     // Cохраняет суммы операций по дням некуммулятивно
  //   graphDataArray = []
  //   for data in dataArrayOfOperationsInternal {
  //     if graphDataArray.isEmpty {
  //       graphDataArray.append(GraphData(newDate: Date.init(timeIntervalSince1970: data.date), newAmount: data.amount))
  //     } else {
  //       for x in graphDataArray {
  //         if returnDayOfDate(x.date) == returnDayOfDate(Date.init(timeIntervalSince1970: data.date)) {
  //           graphDataArray.first { returnDayOfDate($0.date) == returnDayOfDate(Date.init(timeIntervalSince1970: data.date)) }?
  //             .amount += data.amount
  //             // graphDataArray.filter { returnDayOfDate($0.date) == returnDayOfDate(data.date) }
  //             //   .first?.amount += data.amount
  //         }
  //       }
  //       if (graphDataArray.filter { returnDayOfDate($0.date) == returnDayOfDate(Date.init(timeIntervalSince1970: data.date)) }).isEmpty {
  //         graphDataArray.append(GraphData.init(newDate: Date.init(timeIntervalSince1970: data.date), newAmount: data.amount))
  //       }
  //     }
  //   }
  //   graphDataArray.sort { $0.date > $1.date }
  //   print("graphDataArray after sort: \(graphDataArray)")
  // }

  func returnGraphData() -> [GraphData] {
    return graphDataArray
  }

}
