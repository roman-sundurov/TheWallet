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
        do {
            try dataManager.deleteCategory(idOfObject: idOfObject)
        } catch {
            vcSettingDelegate?.showAlert(message: "Error: deleteCategory")
        }
        tableView.reloadData()
    }

    func returnVCMainDelegate() throws -> ProtocolVCMain {
        if let vcMainDelegate = vcMainDelegate {
            return vcMainDelegate
        } else {
            throw ThrowError.vcCategoryReturnVCMainDelegate
        }
    }

    func setCurrentActiveEditingCell(cellID: Int) {
        currentActiveCellID = cellID
        let cells = self.tableView.visibleCells
        var counter = 0
        for cell in cells where counter >= 2 {
                // if counter >= 2 {
            let specCell = cell as? CategoryTableVCCategory
            if cellID == -100 {
                try? specCell?.closeEditing()
            } else {
                if cellID == 0 {
                    specCell?.setPermitionToSetCategory(status: true)
                } else {
                    do {
                        let categoryIDOfCell = try specCell?.returnCategryIdOfCell()
                        if categoryIDOfCell != cellID {
                            try? specCell?.closeEditing()
                            specCell?.setPermitionToSetCategory(status: true)
                        } else {
                            specCell?.setPermitionToSetCategory(status: false)
                        }
                    } catch {
                        vcSettingDelegate?.showAlert(message: "Error: CategoryViewModel setCurrentActiveEditingCell")
                        print("Error: CategoryViewModel setCurrentActiveEditingCell")
                    }
                }
            }
            counter += 1
        }
    }

    func showAlertErrorAddNewCategory() {
        self.present(alertErrorAddNewCategory, animated: true, completion: nil)
    }

    func returnDelegateScreen2ContainerTableVCNewCategory() throws -> ProtocolCategoryTableVCNewCategory {
        if let categoryTableVCNewCategoryDelegate = categoryTableVCNewCategoryDelegate {
            return categoryTableVCNewCategoryDelegate
        } else {
            throw ThrowError.vcCategoryReturnDelegateScreen2ContainerTableVCNewCategory
        }
    }

    func returnScreen2StatusEditContainer() -> Bool {
        return statusEditContainer
    }

    func screen2ContainerNewCategorySwicher() {
        print("AAAA")
        if let userDataOperations = try? dataManager.getUserData().operations,
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
        if let vcMainDelegate = vcMainDelegate {
            do {
                try dataManager.addCategory(name: name, icon: icon, date: date)
            } catch {
                vcSettingDelegate?.showAlert(message: "Error: addNewCategory")
            }
        } else {
            print("addNewCategory vcMainDelegate error")
        }
        if let userCategoriesCount = try? dataManager.getUserData().categories.count {
            print("vcMainDelegate?.getUserData().categories.count = \(userCategoriesCount)")
            tableView.performBatchUpdates({
                var newRowIndex: Int = 0
                // if let categories = try? vcMainDelegate?.getUserData().categories.count {
                newRowIndex = statusEditContainer == true ? userCategoriesCount + 1 : userCategoriesCount
                // }
                tableView.insertRows(at: [IndexPath(row: newRowIndex, section: 0)], with: .automatic)
            }, completion: { _ in
                self.tableView.reloadData()
                // Task {
                //     do {
                //         try await dataManager.fetchFirebase()
                //     } catch {
                //         self.vcSettingDelegate?.showAlert(message: "Error addNewCategory fetchFirebase")
                //     }
                // }
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

    // func getVCSettingDelegate() throws -> ProtocolVCSetting {
    //     if let vcSettingDelegate = vcSettingDelegate {
    //         return vcSettingDelegate
    //     } else {
    //         throw ThrowError.vcCategorygetVCSettingDelegate
    //     }
    // }

    func closeWindow() {
        do {
            try vcSettingDelegate?.changeCategoryClosePopUpScreen2()
            tableView.reloadData()
            categoryTableVCNewCategoryDelegate?.textFieldNewCategoryClear()
            print("ClosePopup from Container")
        } catch {
            vcSettingDelegate?.showAlert(message: "CloseWindow error")
        }
    }

    func calculateCategoryArray() -> [Category] {
        categoriesArray = []
        if let userData = try? dataManager.getUserData() {
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
        if let userCategories = try? dataManager.getUserData().categories {
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
            if let cell = cell {
                return cell
            }
        } else if statusEditContainer == true && indexPath.row == 1 {
            print("2222")
            let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifier.cellNewCategory.rawValue) as? CategoryTableVCNewCategory
            cell?.vcCategoryDelegate = self
            categoryTableVCHeaderDelegate?.buttonOptionsSetColor(color: UIColor.systemBlue)
            categoryTableVCNewCategoryDelegate = cell
            if let cell = cell {
                return cell
            }
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
            if let cell = cell {
                return cell
            }
        }
        return UITableViewCell()
    }

}
