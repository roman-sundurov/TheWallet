//
//  vmMain.swift
//  MoneyManager
//
//  Created by Roman on 27.04.2022.
//

import Foundation
import UIKit

extension VCMain: protocolVCMain {

  func updateuserData(newData: User) {
    userRepository.user = newData
  }

  func updateOperations(amount: Double, category: String, note: String, date: Date, idOfObject: UUID) {
    userRepository.updateOperations(amount: amount, category: category, note: note, date: date, idOfObject: idOfObject)
  }

  func addOperations(amount: Double, category: String, note: String, date: Date) {
    userRepository.addOperations(amount: amount, category: category, note: note, date: date)
  }

  func deleteCategory(idOfObject: UUID) {
    userRepository.deleteCategory(idOfObject: idOfObject)
  }

  func updateCategory(name: String, icon: String, idOfObject: UUID) {
    userRepository.updateCategory(name: name, icon: icon, idOfObject: idOfObject)
  }

  func addCategory(name: String, icon: String) {
    userRepository.addCategory(name: name, icon: icon)
  }

  func deleteOperation(uuid: UUID) {
    userRepository.deleteOperation(idOfObject: uuid)
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

  func returnDelegateScreen1GraphContainer() -> protocolVCGraph {
    return vcGraphDelegate!
  }

  func editOperation(uuid: UUID) {
    hideOperation()
    tagForEdit = uuid
    performSegue(withIdentifier: "segueToScreen2ForEdit", sender: nil)
  }


  func updateScreen() {
      // screen1TableUpdateSorting()
    tableViewScreen1.reloadData()
    countingIncomesAndExpensive()
    changeDaysForSorting(newValue: userRepository.user!.daysForSorting)
    miniGraph.setNeedsDisplay()
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


  func returnArrayForIncrease() -> [Int] {
    return arrayForIncrease
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


    // MARK: - value set functions
  func setDaysForSorting(newValue: Int) {
    userRepository.updateDaysForSorting(daysForSorting: newValue)
    userRepository.user!.daysForSorting = newValue
  }


    // MARK: - data calculating
  func graphDataArrayCalculating(dataArrayOfOperationsInternal: [Operation]) {
      // Данные для передачи в график
      // Cохраняет суммы операций по дням некуммулятивно
    graphDataArray = []
    for data in dataArrayOfOperationsInternal {
      if graphDataArray.isEmpty {
        graphDataArray.append(GraphData.init(newDate: Date.init(timeIntervalSince1970: data.date), newAmount: data.amount))
      } else {
        for x in graphDataArray {
          if returnDayOfDate(x.date) == returnDayOfDate(Date.init(timeIntervalSince1970: data.date)) {
            graphDataArray.first { returnDayOfDate($0.date) == returnDayOfDate(Date.init(timeIntervalSince1970: data.date)) }?
              .amount += data.amount
              // graphDataArray.filter { returnDayOfDate($0.date) == returnDayOfDate(data.date) }
              //   .first?.amount += data.amount
          }
        }
        if (graphDataArray.filter { returnDayOfDate($0.date) == returnDayOfDate(Date.init(timeIntervalSince1970: data.date)) }).isEmpty {
          graphDataArray.append(GraphData.init(newDate: Date.init(timeIntervalSince1970: data.date), newAmount: data.amount))
        }
      }
    }
    graphDataArray.sort { $0.date > $1.date }
    print("graphDataArray after sort: \(graphDataArray)")
  }

  func returnGraphData() -> [GraphData] {
    return graphDataArray
  }


  // MARK: - Обновление сортировки
  func screen1TableUpdateSorting() {
      // if var userData = userData {
      //   let newTime = Date() - TimeInterval.init(86400 * userData.daysForSorting)
      //   userData.operations.sort { $0.date > $1.date }
      //
      //   graphDataArray = graphDataArray
      //     .sorted { $0.date > $1.date }
      //     .filter { $0.date >= newTime }
      //   print("graphDataArray when sort: \(graphDataArray)")
      //
      //   let temporarilyDate = userData.operations.filter { $0.date >= newTime }
      //   userData.operations = temporarilyDate
      // }
  }
}
