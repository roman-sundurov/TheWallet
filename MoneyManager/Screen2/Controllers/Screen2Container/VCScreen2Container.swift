//
//  ViewControllerScreen2Container.swift
//  MoneyManager
//
//  Created by Roman on 22.01.2021.
//

import UIKit

protocol protocolScreen2ContainerDelegate {
  func checkBoxStatus(_ tag: Int, _ type: Bool)
  func closeWindows(_ tag: Int)
  func screen2ContainerNewCategorySwicher()
  func screen2ContainerAddNewCategory()
  func screen2ContainerDeleteCategory(index: Int)
  func presentAlertErrorAddNewCategory()
  func setCurrentActiveEditingCell(categoryID: Int)

  // функции возврата
  func returnDelegateScreen2() -> protocolVCSetting
  func returnScreen2StatusEditContainer() -> Bool
  func returnDelegateScreen2ContainerTableVCNewCategory() -> protocolScreen2ContainerTableVCNewCategory
}

class VCScreen2Container: UIViewController {
  // MARK: - объявление аутлетов

  @IBOutlet var tableViewContainer: UITableView!


  // MARK: - делегаты и переменные

  var delegateScreen2: protocolVCSetting?
  var delegateScreen2ContainerTableVCHeader: protocolScreen2ContainerTableVClHeader?
  var delegateScreen2ContainerTableVCNewCategory: protocolScreen2ContainerTableVCNewCategory?
  var statusEditContainer = false
  var animationNewCategoryInCell = false
  var currentActiveCategoryID: Int = 0


  // MARK: - объекты

  let alertErrorAddNewCategory = UIAlertController(
    title: "Введите название категории",
    message: nil,
    preferredStyle: .alert
    )


  // MARK: - viewDidLoad

  @objc override func viewDidLoad() {
    super.viewDidLoad()

    alertErrorAddNewCategory.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
  }
}

// MARK: - additional protocols

extension VCScreen2Container: protocolScreen2ContainerDelegate {
  func setCurrentActiveEditingCell(categoryID: Int) {
    currentActiveCategoryID = categoryID

    let cells = self.tableViewContainer.visibleCells

    var counter = 0
    for cell in cells {
      if counter >= 2 {
        let specCell = cell as! Screen2ContainerTableVCChangeCategory

        // Значение "-100" используется, чтобы дать сигнал всем ячейкам свернуть редактирование. Использую его, когда поступает команда свернуть PopUp-окно. Чтобы при следующем появлении оно было без редактирования.
        if categoryID == -100 {
          specCell.closeEditing()
        } else {
          if categoryID == 0 {
            specCell.setPermitionToSetCategory(status: true)
          } else {
            if specCell.returnCategryIdOfCell() != categoryID {
              specCell.closeEditing()
              specCell.setPermitionToSetCategory(status: true)
            } else {
              specCell.setPermitionToSetCategory(status: false)
            }
            }
        }
      }
      counter += 1
    }
  }


  func presentAlertErrorAddNewCategory() {
    self.present(alertErrorAddNewCategory, animated: true, completion: nil)
  }


  func returnDelegateScreen2ContainerTableVCNewCategory() -> protocolScreen2ContainerTableVCNewCategory {
    return delegateScreen2ContainerTableVCNewCategory!
  }


  func returnScreen2StatusEditContainer() -> Bool {
    return statusEditContainer
  }


  func screen2ContainerNewCategorySwicher() {
    SettingViewModel.shared.screen2DataReceive()
    print("AAAA")
    if SettingViewModel.shared.returnDataArrayOfCategory().isEmpty == false {
      if statusEditContainer == true {
        statusEditContainer = false
        delegateScreen2ContainerTableVCHeader?.buttonOptionsSetColor(color: UIColor.white)
        tableViewContainer.performBatchUpdates({
          print("AAAA2")
          tableViewContainer.deleteRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        }, completion: { _ in self.tableViewContainer.reloadData() })
      } else {
        print("BBBB")
        statusEditContainer = true
        delegateScreen2ContainerTableVCHeader?.buttonOptionsSetColor(color: UIColor.systemBlue)
        tableViewContainer.performBatchUpdates({
          print("BBBB2")
          tableViewContainer.insertRows(at: [IndexPath(row: 1, section: 0)], with: .automatic)
        }, completion: { _ in self.tableViewContainer.reloadData() })
      }
    }
  }


  func screen2ContainerAddNewCategory() {
    SettingViewModel.shared.screen2DataReceive()
    tableViewContainer.performBatchUpdates({
      let newRowIndex = statusEditContainer == true ?
      SettingViewModel.shared.returnDataArrayOfCategory().count + 1 :
      SettingViewModel.shared.returnDataArrayOfCategory().count
      tableViewContainer.insertRows(at: [IndexPath(row: newRowIndex, section: 0)], with: .automatic)
    }, completion: { _ in self.tableViewContainer.reloadData() })
  }


  func screen2ContainerDeleteCategory(index: Int) {
    SettingViewModel.shared.screen2DataReceive()
    tableViewContainer.performBatchUpdates({
      print("ZZZ2")
      tableViewContainer.deleteRows(at: [IndexPath(row: index + 2, section: 0)], with: .left)
    }, completion: { _ in self.tableViewContainer.reloadData() })
  }


//    func screen2ContainerEditNewCategory(index: Int){
//
//        var newRowIndex = statusEditContainer == true ? (vcSettingDelegate?.returnDataArrayOfCategory().count)! + 1 : (vcSettingDelegate?.returnDataArrayOfCategory().count)!
//
//        ViewModelScreen2.shared.screen2DataReceive()
//        tableViewContainer.reloadData()
//    }


  func returnDelegateScreen2() -> protocolVCSetting {
    return delegateScreen2!
  }


  func closeWindows(_ tag: Int) {
    delegateScreen2?.changeCategoryClosePopUpScreen2()
    tableViewContainer.reloadData()
    delegateScreen2ContainerTableVCNewCategory?.textFieldNewCategoryClear()
    print("ClosePopup from Container")
  }


  func checkBoxStatus(_ tag: Int, _ type: Bool) {
    print("CheckBoxStatus, \(tag)")
    closeWindows(tag)
  }
}

// MARK: - table Functionality
extension VCScreen2Container: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if SettingViewModel.shared.returnDataArrayOfCategory().isEmpty {
      statusEditContainer = true
      return 2
    } else if statusEditContainer == true {
      print("returnDataArrayOfCategory().count 111= \(String(describing: SettingViewModel.shared.returnDataArrayOfCategory().count))")
      return SettingViewModel.shared.returnDataArrayOfCategory().count + 2
    } else {
      print("returnDataArrayOfCategory().count 222= \(String(describing: SettingViewModel.shared.returnDataArrayOfCategory().count))")
      return SettingViewModel.shared.returnDataArrayOfCategory().count + 1
    }
  }


  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    print("indexPath.rowScreen2= \(indexPath.row)")
    if indexPath.row == 0 {
      print("1111")
      let cell = tableView.dequeueReusableCell(withIdentifier: "header") as! Screen2ContainerTableVCHeader
      cell.delegateScreen2Container = self
      delegateScreen2ContainerTableVCHeader = cell
      return cell
    } else if statusEditContainer == true && indexPath.row == 1 {
      print("2222")
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellNewCategory") as! Screen2ContainerTableVCNewCategory
      cell.delegateScreen2Container = self
      delegateScreen2ContainerTableVCHeader?.buttonOptionsSetColor(color: UIColor.systemBlue)
      delegateScreen2ContainerTableVCNewCategory = cell
      return cell
    } else {
      print("3333")
      let cell = tableView.dequeueReusableCell(withIdentifier: "cellChangeCategory") as! Screen2ContainerTableVCChangeCategory
      cell.delegateScreen2Container = self
      cell.setTag(tag: statusEditContainer == true ? indexPath.row - 2 : indexPath.row - 1)
      cell.startCell()
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
