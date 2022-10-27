//
//  VCCategoryViewModel.swift
//  MoneyManager
//
//  Created by Roman on 25.10.2022.
//

import Foundation
import UIKit

extension VCCategory: protocolVCCategory {

  func screen2ContainerDeleteCategory(idOfObject: UUID) {
    vcMainDelegate?.deleteCategory(idOfObject: idOfObject)
    tableView.reloadData()
  }

  func returnVCMainDelegate() -> protocolVCMain {
    return vcMainDelegate!
  }

  func setCurrentActiveEditingCell(cellID: Int) {
    currentActiveCellID = cellID

    let cells = self.tableView.visibleCells

    var counter = 0
    for cell in cells {
      if counter >= 2 {
        let specCell = cell as! CategoryTableVCCategory

          // Значение "-100" используется, чтобы дать сигнал всем ячейкам свернуть редактирование. Использую его, когда поступает команда свернуть PopUp-окно. Чтобы при следующем появлении оно было без редактирования.
        if cellID == -100 {
          specCell.closeEditing()
        } else {
          if cellID == 0 {
            specCell.setPermitionToSetCategory(status: true)
          } else {
            if specCell.returnCategryIdOfCell() != cellID {
              specCell.closeEditing()
              specCell.setPermitionToSetCategory(status: true)
            } else {
              specCell.setPermitionToSetCategory(status: false)
            }
          }

        }
        counter += 1
      }
    }
  }


  func showAlertErrorAddNewCategory() {
    self.present(alertErrorAddNewCategory, animated: true, completion: nil)
  }

  func returnDelegateScreen2ContainerTableVCNewCategory() -> protocolCategoryTableVCNewCategory {
    return categoryTableVCNewCategoryDelegate!
  }

  func returnScreen2StatusEditContainer() -> Bool {
    return statusEditContainer
  }

  func screen2ContainerNewCategorySwicher() {
    print("AAAA")
    if vcMainDelegate?.getUserData().operations.isEmpty == false {
      if statusEditContainer == true {
        statusEditContainer = false
        categoryTableVCHeaderDelegate?.buttonOptionsSetColor(color: UIColor.white)
        tableView.performBatchUpdates({
          print("AAAA2")
          tableView.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        }, completion: { _ in self.tableView.reloadData() })
      } else {
        print("BBBB")
        statusEditContainer = true
        categoryTableVCHeaderDelegate?.buttonOptionsSetColor(color: UIColor.systemBlue)
        tableView.performBatchUpdates({
          print("BBBB2")
          tableView.insertRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        }, completion: { _ in self.tableView.reloadData() })
      }
    }
  }

  func addNewCategory(name: String, icon: String, date: Double) {
    // vcMainDelegate?.fetchFirebase()
    vcMainDelegate!.addCategory(name: name, icon: icon, date: date)
    print("vcMainDelegate!.getUserData().categories.count = \(vcMainDelegate!.getUserData().categories.count)")
    tableView.performBatchUpdates({
      let newRowIndex = statusEditContainer == true ? vcMainDelegate!.getUserData().categories.count + 1 : vcMainDelegate?.getUserData().categories.count
      tableView.insertRows(at: [IndexPath(row: newRowIndex!, section: 0)], with: .automatic)
    }, completion: { _ in
      self.tableView.reloadData()
      self.vcMainDelegate?.fetchFirebase()
    })
  }

  func screen2ContainerDeleteCategory(cellID: Int) {
    tableView.performBatchUpdates({
      print("ZZZ2")
      tableView.deleteRows(at: [IndexPath(row: cellID + 2, section: 0)], with: .left)
    }, completion: { _ in self.tableView.reloadData() })
  }

  func screen2ContainerEditNewCategory(cellID: Int){
    var newRowIndex = statusEditContainer == true ? (vcMainDelegate?.getUserData().operations.count)! + 1 : (vcMainDelegate?.getUserData().operations.count)!
    tableView.reloadData()
  }

  func returnDelegateScreen2() -> protocolVCSetting {
    return vcSettingDelegate!
  }

  func closeWindow() {
    vcSettingDelegate?.changeCategoryClosePopUpScreen2()
    tableView.reloadData()
    categoryTableVCNewCategoryDelegate?.textFieldNewCategoryClear()
    print("ClosePopup from Container")
  }

  func calculateCategoryArray() -> [Category] {
    categoriesArray = []
    if let userData = vcMainDelegate?.getUserData() {
      for oper in userData.categories {
        categoriesArray.append(oper.value)
        categoriesArray.sort() { $0.date > $1.date }
      }
      return categoriesArray
    }
    return []
  }


    // func checkBoxStatus(_ tag: Int, _ type: Bool) {
    //   print("CheckBoxStatus, \(tag)")
    //   closeWindow(tag)
    // }
}

// MARK: - table Functionality
extension VCCategory: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if vcMainDelegate!.getUserData().categories.isEmpty {
      statusEditContainer = true
      return 2
    } else if statusEditContainer == true {
      // print("returnDataArrayOfCategory().count 111= \(String(describing: vcMainDelegate?.getUserData().categories.count))")
      return calculateCategoryArray().count + 2
    } else {
      // print("returnDataArrayOfCategory().count 222= \(String(describing: vcMainDelegate?.getUserData().categories.count))")
      return calculateCategoryArray().count + 1
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    print("indexPath.rowScreen2= \(indexPath.row)")
    if indexPath.row == 0 {
      print("1111")
      let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! CategoryTableVCHeader
      cell.delegateScreen2Container = self
            categoryTableVCHeaderDelegate = cell
      return cell
    } else if statusEditContainer == true && indexPath.row == 1 {
      print("2222")
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellNewCategory") as! CategoryTableVCNewCategory
      cell.vcCategoryDelegate = self
      categoryTableVCHeaderDelegate?.buttonOptionsSetColor(color: UIColor.systemBlue)
      categoryTableVCNewCategoryDelegate = cell
      return cell
    } else {
      print("3333")
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellChangeCategory") as! CategoryTableVCCategory
      cell.vcCategoryDelegate = self
      cell.vcSettingDelegate = vcSettingDelegate
      cell.vcMainDelegate = vcMainDelegate
      cell.startCell(
        category: categoriesArray[statusEditContainer == true ? indexPath.row - 2 : indexPath.row - 1],
        cellID: statusEditContainer == true ? indexPath.row - 2 : indexPath.row - 1
      )
      return cell
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
