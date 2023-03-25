//
//  VCCategoryViewModel.swift
//  MoneyManager
//
//  Created by Roman on 25.10.2022.
//

import Foundation
import UIKit

extension VCCategory: ProtocolVCCategory {
    func screen2ContainerDeleteCategory(idOfObject: UUID) {
        vcMainDelegate?.deleteCategory(idOfObject: idOfObject)
        tableView.reloadData()
    }

    func returnVCMainDelegate() -> ProtocolVCMain {
        return vcMainDelegate!
    }

    func setCurrentActiveEditingCell(cellID: Int) {
        currentActiveCellID = cellID
        let cells = self.tableView.visibleCells
        var counter = 0
        for cell in cells where counter >= 2 {
                // if counter >= 2 {
            let specCell = cell as? CategoryTableVCCategory
            if cellID == -100 {
                specCell?.closeEditing()
            } else {
                if cellID == 0 {
                    specCell?.setPermitionToSetCategory(status: true)
                } else {
                    if specCell?.returnCategryIdOfCell() != cellID {
                        specCell?.closeEditing()
                        specCell?.setPermitionToSetCategory(status: true)
                    } else {
                        specCell?.setPermitionToSetCategory(status: false)
                    }
                }
            }
            counter += 1
                // }
        }
    }

    func showAlertErrorAddNewCategory() {
        self.present(alertErrorAddNewCategory, animated: true, completion: nil)
    }

    func returnDelegateScreen2ContainerTableVCNewCategory() -> ProtocolCategoryTableVCNewCategory {
        return categoryTableVCNewCategoryDelegate!
    }

    func returnScreen2StatusEditContainer() -> Bool {
        return statusEditContainer
    }

    func screen2ContainerNewCategorySwicher() {
        print("AAAA")
        if let userDataOperations = try? vcMainDelegate?.getUserData().operations,
           userDataOperations.isEmpty == false {
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
        if let userCategoriesCount = try? vcMainDelegate!.getUserData().categories.count {
            print("vcMainDelegate!.getUserData().categories.count = \(userCategoriesCount)")
            tableView.performBatchUpdates({
                var newRowIndex: Int = 0
                // if let categories = try? vcMainDelegate?.getUserData().categories.count {
                newRowIndex = statusEditContainer == true ? userCategoriesCount + 1 : userCategoriesCount
                // }
                tableView.insertRows(at: [IndexPath(row: newRowIndex, section: 0)], with: .automatic)
            }, completion: { _ in
                self.tableView.reloadData()
                Task {
                    await self.vcMainDelegate?.fetchFirebase()
                }
            })
        } else {
            vcSettingDelegate?.showAlert(message: "addNewCategory error")
        }
    }

    func screen2ContainerDeleteCategory(cellID: Int) {
        tableView.performBatchUpdates({
            print("ZZZ2")
            tableView.deleteRows(at: [IndexPath(row: cellID + 2, section: 0)], with: .left)
        }, completion: { _ in self.tableView.reloadData() })
    }

    func getVCSettingDelegate() -> ProtocolVCSetting {
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
        if let userData = try? vcMainDelegate?.getUserData() {
            for oper in userData.categories {
                categoriesArray.append(oper.value)
                categoriesArray.sort { $0.date > $1.date }
            }
            return categoriesArray
        }
        return []
    }
}

// MARK: - table Functionality
extension VCCategory: UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension VCCategory: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let userCategories = try? vcMainDelegate!.getUserData().categories {
            if userCategories.isEmpty {
                statusEditContainer = true
                return 2
            } else if statusEditContainer == true {
                return calculateCategoryArray().count + 2
            } else {
                return calculateCategoryArray().count + 1
            }
        } else {
            statusEditContainer = true
            return 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("indexPath.rowScreen2= \(indexPath.row)")
        if indexPath.row == 0 {
            print("1111")
            let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifier.header.rawValue) as? CategoryTableVCHeader
            cell?.delegateScreen2Container = self
            categoryTableVCHeaderDelegate = cell
            return cell!
        } else if statusEditContainer == true && indexPath.row == 1 {
            print("2222")
            let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifier.cellNewCategory.rawValue) as? CategoryTableVCNewCategory
            cell?.vcCategoryDelegate = self
            categoryTableVCHeaderDelegate?.buttonOptionsSetColor(color: UIColor.systemBlue)
            categoryTableVCNewCategoryDelegate = cell
            return cell!
        } else {
            print("3333")
            let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifier.cellChangeCategory.rawValue) as? CategoryTableVCCategory
            cell?.vcCategoryDelegate = self
            cell?.vcSettingDelegate = vcSettingDelegate
            cell?.vcMainDelegate = vcMainDelegate
            cell?.startCell(
                category: categoriesArray[statusEditContainer == true ? indexPath.row - 2 : indexPath.row - 1],
                cellID: statusEditContainer == true ? indexPath.row - 2 : indexPath.row - 1
            )
            return cell!
        }
    }

}
