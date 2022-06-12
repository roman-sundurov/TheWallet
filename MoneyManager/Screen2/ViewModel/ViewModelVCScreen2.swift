//
//  ViewModelVCScreen2.swift
//  SkillboxDiplomaStep1
//
//  Created by Roman on 28.04.2022.
//

import Foundation

class ViewModelScreen2 {
  static let shared = ViewModelScreen2()

  private var dataArrayOfCategory: [DataOfCategories] = [] // хранение оригинала данных из Realm
  private var screen2MenuArray: [Screen2MenuData] = []
  private var newOperation = ListOfOperations()

  // MARK: - функции возврата
  func returnDataArrayOfCategory() -> [DataOfCategories] {
    return dataArrayOfCategory
  }


  // MARK: - data
  func menuArrayCalculate() {
    let screen2MenuList0 = Screen2MenuData(name: "Header", text: "")
    let screen2MenuList1 = Screen2MenuData(name: "Category", text: "Select category")
    let screen2MenuList2 = Screen2MenuData(name: "Date", text: "Today")
    let screen2MenuList3 = Screen2MenuData(name: "Notes", text: "")
    screen2MenuArray = [screen2MenuList0, screen2MenuList1, screen2MenuList2, screen2MenuList3]
  }

  func returnScreen2MenuArray() -> [Screen2MenuData] {
    return screen2MenuArray
  }

  func screen2DataReceive() {
    dataArrayOfCategory = []
    for category in Persistence.shared.returnRealmDataCategories() {
      dataArrayOfCategory.append(DataOfCategories(name1: category.name, icon1: category.icon, id1: category.id))
    }
  }

  func setAmountInNewOperation(amount: Double) {
    newOperation.amount = amount
  }

  func setCategoryInNewOperation(category: String) {
    newOperation.category = category
  }

  func setDateInNewOperation(date: Date) {
    newOperation.date = date
  }

  func setNoteInNewOperation(note: String) {
    newOperation.note = note
  }

  func setIDInNewOperation(id: Int) {
    newOperation.id = id
  }

  func returnNewOperation() -> ListOfOperations {
    return newOperation
  }
}
